import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_service.dart';
import 'core/services/my_audio_handler.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/quran_repository.dart';
import 'presentation/blocs/audio_player/audio_player_bloc.dart';
import 'presentation/blocs/favorite/favorite_bloc.dart';
import 'presentation/blocs/favorite/favorite_event.dart';
import 'presentation/blocs/quran/quran_bloc.dart';
import 'presentation/blocs/quran/quran_event.dart';
import 'presentation/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.alquran.channel.audio',
      androidNotificationChannelName: 'Al-Quran Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(MyApp(audioHandler: audioHandler));
}

class MyApp extends StatelessWidget {
  final MyAudioHandler audioHandler;

  const MyApp({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ApiService()),
        RepositoryProvider.value(value: audioHandler),
        RepositoryProvider(
          create: (context) => QuranRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(create: (_) => FavoriteRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => QuranBloc(
              repository: context.read<QuranRepository>(),
            )..add(FetchInitialData()),
          ),
          BlocProvider(
            create: (context) => AudioPlayerBloc(
              audioHandler: context.read<MyAudioHandler>(),
              apiService: context.read<ApiService>(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc(
              repository: context.read<FavoriteRepository>(),
            )..add(LoadFavorites()),
          ),
        ],
        child: MaterialApp(
          title: 'Al-Quran Player',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1DB954), // Spotify Green
              brightness: Brightness.dark,
              surface: const Color(0xFF121212),
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF181818),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              elevation: 0,
            ),
          ),
          home: const MainScreen(),
        ),
      ),
    );
  }
}
