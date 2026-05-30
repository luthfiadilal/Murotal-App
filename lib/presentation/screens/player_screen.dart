import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/favorite_item_model.dart';
import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/audio_player/audio_player_state.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';
import '../blocs/surah_detail/surah_detail_bloc.dart';
import '../blocs/surah_detail/surah_detail_event.dart';
import 'lyrics_screen.dart';
import 'queue_screen.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int? _lastFetchedSurahNumber;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AudioPlayerBloc>().state;
      if (state.currentSurah != null) {
        _lastFetchedSurahNumber = state.currentSurah!.number;
        context
            .read<SurahDetailBloc>()
            .add(FetchSurahDetail(_lastFetchedSurahNumber!));
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A4A4A),
              Color(0xFF121212),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AudioPlayerBloc, AudioPlayerState>(
            listener: (context, state) {
              if (state.currentSurah != null &&
                  state.currentSurah!.number != _lastFetchedSurahNumber) {
                _lastFetchedSurahNumber = state.currentSurah!.number;
                context
                    .read<SurahDetailBloc>()
                    .add(FetchSurahDetail(_lastFetchedSurahNumber!));
              }
            },
            child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
              builder: (context, state) {
                final surah = state.currentSurah;
                final qari = state.currentQari;

                if (surah == null || qari == null) {
                  return const Center(child: Text('No Audio Playing'));
                }

                final favoriteItem =
                    FavoriteItemModel(surah: surah, qari: qari);

                return Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down,
                                size: 32),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Now Playing',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Cover Art
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.music_note,
                                size: 100, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),

                    // Song Info & Favorite
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.englishName ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  qari.englishName ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<FavoriteBloc, FavoriteState>(
                            builder: (context, favState) {
                              bool isFav = false;
                              if (favState is FavoriteLoaded) {
                                isFav = favState.favorites
                                    .any((f) => f.id == favoriteItem.id);
                              }
                              return IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? const Color(0xFF1DB954)
                                      : Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  if (isFav) {
                                    context
                                        .read<FavoriteBloc>()
                                        .add(RemoveFavorite(favoriteItem));
                                  } else {
                                    context
                                        .read<FavoriteBloc>()
                                        .add(AddFavorite(favoriteItem));
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              min: 0,
                              max: state.totalDuration.inSeconds.toDouble() > 0
                                  ? state.totalDuration.inSeconds.toDouble()
                                  : 1,
                              value: state.currentPosition.inSeconds
                                  .toDouble()
                                  .clamp(
                                    0,
                                    state.totalDuration.inSeconds.toDouble() > 0
                                        ? state.totalDuration.inSeconds.toDouble()
                                        : 1,
                                  ),
                              onChanged: (value) {
                                context.read<AudioPlayerBloc>().add(
                                      SeekAudio(Duration(seconds: value.toInt())),
                                    );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(state.currentPosition),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                Text(
                                  _formatDuration(state.totalDuration),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Controls
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shuffle,
                                size: 28, color: Colors.white54),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous, size: 40),
                            onPressed: () {},
                          ),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                state.isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 40,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                final bloc = context.read<AudioPlayerBloc>();
                                if (state.isPlaying) {
                                  bloc.add(PauseAudio());
                                } else {
                                  bloc.add(ResumeAudio());
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, size: 40),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat,
                                size: 28, color: Colors.white54),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    
                    // Bottom Actions (Lyrics & Queue)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.lyrics_outlined, size: 24, color: Colors.white70),
                            tooltip: "Lirik (Ayat)",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LyricsScreen(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.queue_music, size: 24, color: Colors.white70),
                            tooltip: "Antrean",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QueueScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
