import 'package:equatable/equatable.dart';

import '../../../data/models/favorite_item_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final FavoriteItemModel item;

  const AddFavorite(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFavorite extends FavoriteEvent {
  final FavoriteItemModel item;

  const RemoveFavorite(this.item);

  @override
  List<Object?> get props => [item];
}
