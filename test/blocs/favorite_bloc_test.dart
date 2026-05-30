import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/repositories/favorite_repository.dart';
import 'package:alquran/data/models/favorite_item_model.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_event.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_state.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late MockFavoriteRepository mockRepository;
  late FavoriteBloc favoriteBloc;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    favoriteBloc = FavoriteBloc(repository: mockRepository);
  });

  tearDown(() {
    favoriteBloc.close();
  });

  group('FavoriteBloc Tests', () {
    final item = FavoriteItemModel(
      surah: const SurahModel(number: 1, name: "Al-Fatihah"),
      qari: const EditionModel(identifier: "ar.alafasy", name: "Alafasy"),
    );

    test('initial state is FavoriteInitial', () {
      expect(favoriteBloc.state, isA<FavoriteInitial>());
    });

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [FavoriteLoading, FavoriteLoaded] on LoadFavorites',
      build: () {
        when(() => mockRepository.getFavorites()).thenAnswer((_) async => [item]);
        return favoriteBloc;
      },
      act: (bloc) => bloc.add(LoadFavorites()),
      expect: () => [
        isA<FavoriteLoading>(),
        isA<FavoriteLoaded>().having((s) => s.favorites.length, 'length', 1),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [FavoriteLoaded] on AddFavorite',
      build: () {
        when(() => mockRepository.saveFavorite(item)).thenAnswer((_) async {});
        when(() => mockRepository.getFavorites()).thenAnswer((_) async => [item]);
        return favoriteBloc;
      },
      act: (bloc) => bloc.add(AddFavorite(item)),
      expect: () => [
        isA<FavoriteLoaded>().having((s) => s.favorites.length, 'length', 1),
      ],
    );
  });
}
