import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:flutter/material.dart';

class ShoppingListSearch extends SearchDelegate {

  ShoppingListSearch({ 
    required this.filledCategories, 
    required this.suggestionsBuilder,
  });
  
  final List<Category>? filledCategories;
  final Widget Function(List<Category>) suggestionsBuilder;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      ),      
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text("Buscar"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This are the suggestions that are showed to the user.
    if (query.isEmpty) return Container();

    List<Category>? foundData = [];

    final foundCategories = filledCategories?.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList() ?? [];
    final foundItems = filledCategories?.expand((c) => c.items).where((it) => it.name.toLowerCase().contains(query.toLowerCase())).toList() ?? [];

    for (final item in foundItems) {
      final category = filledCategories?.firstWhere((c) => c.id == item.categoryId);
      foundData.add(category!);
    }

    // ignore: prefer_collection_literals
    foundData = [...foundData, ...foundCategories].toSet().toList();

    if (foundData.isEmpty) {
      return const Center(child: Text("No results!"));
    }

    return suggestionsBuilder(foundData);
  }

}
