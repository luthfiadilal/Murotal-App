import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/quran/quran_bloc.dart';
import '../blocs/quran/quran_state.dart';
import '../widgets/mini_equalizer.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Antrean Berikutnya', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoaded) {
            final surahs = state.allSurahs;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                final audioState = context.watch<AudioPlayerBloc>().state;
                final isCurrent = surah.number == audioState.currentSurah?.number;
                final isPlaying = audioState.isPlaying;

                return ListTile(
                  leading: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: isCurrent
                        ? MiniEqualizer(isPlaying: isPlaying)
                        : Text(
                            surah.number.toString(),
                            style: const TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                  ),
                  title: Text(
                    surah.englishName ?? '',
                    style: TextStyle(
                      color: isCurrent ? const Color(0xFF1DB954) : Colors.white,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    '${surah.revelationType} • ${surah.numberOfAyahs} Verses',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: Text(
                    surah.name ?? '',
                    style: const TextStyle(fontSize: 20, color: Colors.white54),
                  ),
                  onTap: () {
                    if (audioState.currentQari != null) {
                      context.read<AudioPlayerBloc>().add(
                            PlayAudio(surah: surah, qari: audioState.currentQari!),
                          );
                    }
                  },
                );
              },
            );
          }
          return const Center(child: Text('Memuat antrean...'));
        },
      ),
    );
  }
}
