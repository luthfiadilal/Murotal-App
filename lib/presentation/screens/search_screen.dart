import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
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
                hintText: 'What do you want to listen to?',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.white,
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
                  final surahs = state.filteredSurahs;
                  final defaultQari = state.allQaris.isNotEmpty
                      ? state.allQaris.firstWhere((q) => q.identifier == 'ar.alafasy',
                          orElse: () => state.allQaris.first)
                      : null;

                  if (surahs.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      return ListTile(
                        leading: const Icon(Icons.music_note, color: Colors.grey),
                        title: Text(surah.englishName ?? ''),
                        subtitle: Text('Surah • ${surah.englishNameTranslation}'),
                        onTap: () {
                          if (defaultQari != null) {
                            context.read<AudioPlayerBloc>().add(
                                  PlayAudio(surah: surah, qari: defaultQari),
                                );
                          }
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
