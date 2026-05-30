import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio_player/audio_player_bloc.dart';
import '../blocs/audio_player/audio_player_event.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  'Your playlist is empty.\nStart adding your favorite surahs!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3AA58),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                  title: Text(item.surah.englishName ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.qari.englishName ?? ''),
                  onTap: () {
                    context.read<AudioPlayerBloc>().add(
                          PlayAudio(surah: item.surah, qari: item.qari),
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
