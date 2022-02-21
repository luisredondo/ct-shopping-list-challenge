import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';

class CategoryExpandableContainer extends StatelessWidget {

  const CategoryExpandableContainer({ 
    Key? key,
    required this.category,
    required this.items,
    required this.onCategoryDelete,
    required this.onItemDelete,
    required this.onItemAddToFavorites,
  }) : super(key: key);

  final Category category;
  final List<Item> items;
  final void Function(Category) onCategoryDelete;
  final void Function(Item) onItemDelete;
  final void Function(Item) onItemAddToFavorites;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(category.name),
      background: Container(),
      secondaryBackground: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      child: ExpandablePanel(
        controller: ExpandableController(
          initialExpanded: true,
        ),
        header: ListTile(
          title: Container(
            width: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(category.name),
          ),
        ),
        collapsed: Container(),
        expanded: ReorderableListView(
          onReorder: (oldIndex, newIndex) => print('Reordered $oldIndex to $newIndex'),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            for (final item in items) ...[
              Dismissible(
                key: Key(item.name),
                background: Container(color: Colors.yellow),
                secondaryBackground: Container(color: Colors.red),
                child: ListTile(
                  title: Text(item.name),
                  leading: Image.network(item.image),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    onItemDelete(item);
                  } else {
                    onItemAddToFavorites(item);
                  }
                },
              )
            ]
          ],
        ),
      ),
      onDismissed: (direction) {
        // TODO: Ask the user if they want to delete the category
        onCategoryDelete(category);
      },
    );
  }
}