import 'package:ct_shopping_list_challenge/cubits/shopping_list/shopping_list_cubit.dart';
import 'package:ct_shopping_list_challenge/cubits/shopping_list/shopping_list_state.dart';
import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/widgets/shopping_list/search_delegate.dart';
import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';

import 'package:ct_shopping_list_challenge/widgets/shopping_list/category_expandable_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListCubit()..loadFilledCategories(),
      child: const ShoppingListView(),
    );
  }
}

class ShoppingListView extends StatelessWidget {

  const ShoppingListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingListCubit, ShoppingListViewState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.lastFavoriteCount < state.favoriteCount) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Added to favorites!'),
            ),);
          }
        }
      },
      builder: (context, state) {
        return MyScaffold(
          appBarTitle: "Shopping List",
          appBarActions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (state is LoadedState) {
                  showSearch(
                    context: context, 
                    delegate: ShoppingListSearch(
                      filledCategories: state.shoppingList,
                      suggestionsBuilder: (categories) => buildListOfCategoriesAndItems(
                        context: context, 
                        shoppingList: categories,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
          body: Builder(
            builder: (context) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedState) {
                return buildListOfCategoriesAndItems(
                  context: context, 
                  shoppingList: state.shoppingList,
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  Widget buildListOfCategoriesAndItems({
    required BuildContext context, 
    required List<Category> shoppingList,
  }) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: size.height * 0.1,
      ),
      itemCount: shoppingList.length,
      itemBuilder: (context, index) {
        final category = shoppingList[index];
        return CategoryExpandableContainer(
          category: category, 
          items: category.items,
          onCategoryDelete: (category) => context.read<ShoppingListCubit>().deleteCategory(category),
          onItemDelete: (categoy, item) => context.read<ShoppingListCubit>().deleteItem(category, item),
          onItemFavoritesEvent: (category, item) => context.read<ShoppingListCubit>().toggleFavorites(category, item),
          onCategoyDeleteConfirm: () async => askPermissionToDeleteCategory(context),
          onItemDeleteConfirm: () async => askPermissionToDeleteItem(context),
        );
      },
    );
  }
  
  Future<bool> askPermissionToDeleteCategory(BuildContext context) 
    => askPermissionToDelete(context, message: "¿Estás seguro de que quieres eliminar la categoría y todos sus elementos?");

  Future<bool> askPermissionToDeleteItem(BuildContext context) 
    => askPermissionToDelete(context, message: "¿Estás seguro de que quieres eliminar este elemento?");

  Future<bool> askPermissionToDelete(BuildContext context, { String? message }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CUIDADO!'),
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

}
