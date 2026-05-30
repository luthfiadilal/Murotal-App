import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/favorite_item_model.dart';
import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/quran/quran_bloc.dart';
import '../blocs/quran/quran_event.dart';
import '../blocs/quran/quran_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
                hintText: 'Cari Surah atau Nama Qari...',
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
          Expanded(
            child: BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                if (state is QuranLoaded) {
                  final query = state.searchQuery?.trim().toLowerCase() ?? '';
                  
                  if (query.isEmpty) {
                    return const Center(
                      child: Text(
                        'Ketik untuk mencari surah atau qari',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final List<FavoriteItemModel> searchResults = [];
                  final Set<String> seenIds = {};

                  // 1. Jika pencarian cocok dengan nama Surah
                  for (var surah in state.filteredSurahs) {
                    for (var qari in state.allQaris) {
                      final item = FavoriteItemModel(surah: surah, qari: qari);
                      if (!seenIds.contains(item.id)) {
                        searchResults.add(item);
                        seenIds.add(item.id);
                      }
                    }
                  }

                  // 2. Jika pencarian cocok dengan nama Qari
                  for (var qari in state.filteredQaris) {
                    for (var surah in state.allSurahs) {
                      final item = FavoriteItemModel(surah: surah, qari: qari);
                      if (!seenIds.contains(item.id)) {
                        searchResults.add(item);
                        seenIds.add(item.id);
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
