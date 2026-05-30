import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/favorite_item_model.dart';
import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/quran/quran_bloc.dart';
import '../blocs/quran/quran_event.dart';
import '../blocs/quran/quran_state.dart';
import '../../data/models/edition_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  EditionModel? _selectedQari;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkEmerald,
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                context.read<QuranBloc>().add(SearchQuran(value));
              },
              decoration: InputDecoration(
                hintText: 'Cari Surah...',
                prefixIcon: const Icon(Icons.search, color: AppColors.darkEmerald),
                fillColor: AppColors.ivoryWhite,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.black54),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          BlocBuilder<QuranBloc, QuranState>(
            builder: (context, state) {
              if (state is QuranLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Deduplikasi Qari berdasarkan nama agar tidak ada nama ganda di Dropdown
                      final uniqueQaris = <String, EditionModel>{};
                      for (var qari in state.allQaris) {
                        final name = qari.englishName ?? qari.name ?? '';
                        if (!uniqueQaris.containsKey(name)) {
                          uniqueQaris[name] = qari;
                        }
                      }

                      return DropdownMenu<EditionModel>(
                        width: constraints.maxWidth,
                        initialSelection: _selectedQari,
                        hintText: 'Filter Qari (Semua Qari)',
                        textStyle: const TextStyle(color: Colors.black),
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: AppColors.ivoryWhite,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSelected: (EditionModel? qari) {
                          setState(() {
                            _selectedQari = qari;
                          });
                        },
                        dropdownMenuEntries: [
                          const DropdownMenuEntry<EditionModel>(
                            value: EditionModel(identifier: 'all', format: '', type: ''), // Dummy for "All"
                            label: 'Semua Qari',
                          ),
                          ...uniqueQaris.values.map<DropdownMenuEntry<EditionModel>>((EditionModel qari) {
                            return DropdownMenuEntry<EditionModel>(
                              value: qari,
                              label: qari.englishName ?? qari.name ?? '',
                            );
                          }),
                        ],
                      );
                    }
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                if (state is QuranLoaded) {
                  final query = state.searchQuery?.trim().toLowerCase() ?? '';
                  
                  if (query.isEmpty && _selectedQari == null) {
                    return const Center(
                      child: Text(
                        'Ketik surah atau pilih Qari',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final List<FavoriteItemModel> searchResults = [];
                  final Set<String> seenIds = {};
                  
                  // Menentukan daftar Qari yang akan ditampilkan
                  List<EditionModel> targetQaris = state.allQaris;
                  if (_selectedQari != null && _selectedQari!.identifier != 'all') {
                    targetQaris = [_selectedQari!];
                  }

                  // 1. Jika pencarian cocok dengan nama Surah (atau query kosong tapi Qari dipilih)
                  final surahsToSearch = query.isEmpty ? state.allSurahs : state.filteredSurahs;
                  for (var surah in surahsToSearch) {
                    for (var qari in targetQaris) {
                      final item = FavoriteItemModel(surah: surah, qari: qari);
                      if (!seenIds.contains(item.id)) {
                        searchResults.add(item);
                        seenIds.add(item.id);
                      }
                    }
                  }

                  // 2. Jika pencarian cocok dengan nama Qari (hanya berguna jika tidak ada Qari yang difilter khusus)
                  if (_selectedQari == null || _selectedQari!.identifier == 'all') {
                    for (var qari in state.filteredQaris) {
                      for (var surah in state.allSurahs) {
                        final item = FavoriteItemModel(surah: surah, qari: qari);
                        if (!seenIds.contains(item.id)) {
                          searchResults.add(item);
                          seenIds.add(item.id);
                        }
                      }
                    }
                  }

                  if (searchResults.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada hasil yang ditemukan',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      final surah = item.surah;
                      final qari = item.qari;

                      return ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.library_music_rounded, color: AppColors.premiumGold),
                        ),
                        title: Text(
                          surah.englishName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Surah • ${qari.englishName ?? qari.name}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: AppColors.premiumGold, size: 32),
                          onPressed: () {
                            context.read<AudioPlayerBloc>().add(
                                  PlayAudio(surah: surah, qari: qari),
                                );
                          },
                        ),
                        onTap: () {
                          context.read<AudioPlayerBloc>().add(
                                PlayAudio(surah: surah, qari: qari),
                              );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
