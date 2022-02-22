import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';
import 'package:ct_shopping_list_challenge/widgets/shopping_list/category_expandable_container.dart';
import 'package:ct_shopping_list_challenge/cubits/favorites/favorites_cubit.dart';
import 'package:ct_shopping_list_challenge/cubits/favorites/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesCubit()..loadFilledCategories(),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {

  const FavoritesView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<FavoritesCubit, FavoritesViewState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.favoriteCount < state.lastFavoriteCount) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Removed from favorites!'),
            ),);
          }
        }
      },
      builder: (context, state) {
        return MyScaffold(
          appBarTitle: "Favorites",
          body: Builder(
            builder: (context) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedState) {
                return ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.1,
                  ),
                  itemCount: state.favoritesList.length,
                  itemBuilder: (context, index) {
                    final category = state.favoritesList[index];
                    return CategoryExpandableContainer(
                      category: category, 
                      items: category.items,
                      addedDateBuilder: (item) => Text(item.addedToFavoritesAt.toString().substring(0, 10)),
                      onCategoryDelete: (category) => {},
                      onItemDelete: (categoy, item) => {},
                      onItemFavoritesEvent: (category, item) => context.read<FavoritesCubit>().toggleFavorites(category, item),
                      onCategoyDeleteConfirm: () async => false,
                      onItemDeleteConfirm: () async => false,
                    );
                  },
                );
              } else if (state is EmptyState) {
                return const Center(child: Text("Strill nothing!"),);
              } else {
                return const Center(child: Text("Something went wrong!"),);
              }
            },
          ),
        );
      },
    );
  }

}
