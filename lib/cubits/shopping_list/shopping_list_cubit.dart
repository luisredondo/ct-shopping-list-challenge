import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ct_shopping_list_challenge/config/config.locator.dart';
import 'package:ct_shopping_list_challenge/services/database_service.dart';
import 'package:ct_shopping_list_challenge/cubits/shopping_list/shopping_list_state.dart';
import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';

class ShoppingListCubit extends Cubit<ShoppingListViewState> {

  ShoppingListCubit() : super(InitialState());

  final _databaseService = locator<DatabaseService>();

  void loadFilledCategories() {
    emit(LoadingState());
    _databaseService.streamFilledCategories().listen((categories) {
      if (categories.isNotEmpty) {
        final items = categories.expand((element) => element.items).toList();
        final newCount = items.where((item) => item.isFavorite).length;
        emit(LoadedState(
          shoppingList: categories,
          favoriteCount: newCount,
          lastFavoriteCount: state is LoadedState ? (state as LoadedState).favoriteCount : newCount,
        ),);
      }
    });
  }

  Future<void> deleteCategory(Category category) async {
    await _databaseService.deleteCategory(category);
  }

  Future<void> deleteItem(Category category, Item item) async {
    await _databaseService.deleteItem(category, item);
  }

  Future<void> toggleFavorites(Category category, Item item) async {
    if (item.isFavorite) {
      await _databaseService.updateItem(category, item.copyWith(
        isFavorite: false,
      ),);
    } else {
      await _databaseService.updateItem(category, item.copyWith(
        isFavorite: true,
        addedToFavoritesAt: DateTime.now(),
      ),);
    }
  }

}
