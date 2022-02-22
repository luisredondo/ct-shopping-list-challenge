



import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:equatable/equatable.dart';

abstract class FavoritesViewState extends Equatable {}

class InitialState extends FavoritesViewState {
  @override
  List<Object> get props => [];
}

class LoadingState extends FavoritesViewState {
  @override
  List<Object> get props => [];
}

class LoadedState extends FavoritesViewState {

  LoadedState({
    required this.favoritesList,
    required this.favoriteCount,
    required this.lastFavoriteCount,
  });

  final List<Category> favoritesList;
  final int favoriteCount;
  final int lastFavoriteCount;

  LoadedState copyWith({
    List<Category>? favoritesList,
    int? favoriteCount,
    int? lastFavoriteCount,
  }) {
    return LoadedState(
      favoritesList: favoritesList ?? this.favoritesList,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      lastFavoriteCount: lastFavoriteCount ?? this.lastFavoriteCount,
    );
  }

  @override
  List<Object> get props => [favoritesList, favoriteCount];
}

class ToggleFavoritesState extends FavoritesViewState {
  @override
  List<Object> get props => [];
}

class EmptyState extends FavoritesViewState {
  @override
  List<Object> get props => [];
}

class ErrorState extends FavoritesViewState {
  @override
  List<Object> get props => [];
}
