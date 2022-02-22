



import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:equatable/equatable.dart';

abstract class ShoppingListViewState extends Equatable {}

class InitialState extends ShoppingListViewState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ShoppingListViewState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ShoppingListViewState {

  LoadedState({
    required this.shoppingList,
    required this.favoriteCount,
    required this.lastFavoriteCount,
  });

  final List<Category> shoppingList;
  final int favoriteCount;
  final int lastFavoriteCount;

  LoadedState copyWith({
    List<Category>? shoppingList,
    int? favoriteCount,
    int? lastFavoriteCount,
  }) {
    return LoadedState(
      shoppingList: shoppingList ?? this.shoppingList,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      lastFavoriteCount: lastFavoriteCount ?? this.lastFavoriteCount,
    );
  }

  @override
  List<Object> get props => [shoppingList, favoriteCount];
}

class ToggleFavoritesState extends ShoppingListViewState {
  @override
  List<Object> get props => [];
}

class EmptyState extends ShoppingListViewState {
  @override
  List<Object> get props => [];
}

class ErrorState extends ShoppingListViewState {
  @override
  List<Object> get props => [];
}
