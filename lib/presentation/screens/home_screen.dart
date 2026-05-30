import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/audio_player/audio_player_state.dart';
import '../blocs/quran/quran_bloc.dart';
import '../widgets/mini_equalizer.dart';
import '../blocs/quran/quran_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Al-Quran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuranError) {
            return Center(child: Text(state.message));
          } else if (state is QuranLoaded) {
            final surahs = state.allSurahs;
            final defaultQari = state.allQaris.isNotEmpty
                ? state.allQaris.firstWhere((q) => q.identifier == 'ar.alafasy',
                    orElse: () => state.allQaris.first)
                : null;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80), // Padding for mini player
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                  builder: (context, audioState) {
                    final isCurrentSurah = audioState.currentSurah?.number == surah.number;
                    final isPlaying = audioState.isPlaying;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isCurrentSurah 
                          ? MiniEqualizer(isPlaying: isPlaying)
                          : Text(
                              '${surah.number}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                      ),
                      title: Text(
                        surah.englishName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isCurrentSurah ? AppColors.premiumGold : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${surah.revelationType} • ${surah.numberOfAyahs} Ayahs',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      trailing: Text(
                        surah.name ?? '',
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
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
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
