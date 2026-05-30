import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/audio_player/audio_player_state.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state.currentSurah == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PlayerScreen(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Cover Art Placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.currentSurah?.englishName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        state.currentQari?.englishName ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final bloc = context.read<AudioPlayerBloc>();
                    if (state.isPlaying) {
                      bloc.add(PauseAudio());
                    } else if (state.isPaused) {
                      bloc.add(ResumeAudio());
                    } else {
                      // Fallback
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
