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
    required this.onItemFavoritesEvent,
    required this.onCategoyDeleteConfirm,
    required this.onItemDeleteConfirm,
    this.addedDateBuilder
  }) : super(key: key);

  final Category category;
  final List<Item> items;
  final void Function(Category) onCategoryDelete;
  final void Function(Category, Item) onItemDelete;
  final void Function(Category, Item) onItemFavoritesEvent;
  final Future<bool> Function() onCategoyDeleteConfirm;
  final Future<bool> Function() onItemDeleteConfirm;
  final Widget? Function(Item)? addedDateBuilder;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(category.id),
      background: Container(),
      secondaryBackground: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        final bool confirm = await onCategoyDeleteConfirm();
        return confirm;
      },
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
                key: Key(item.id),
                background: Container(color: Colors.yellow),
                secondaryBackground: Container(color: Colors.red),
                confirmDismiss: (DismissDirection direction) async {
                  bool confirm = false;
                  if (direction == DismissDirection.startToEnd) {
                    onItemFavoritesEvent(category, item);
                  } else if (direction == DismissDirection.endToStart) {
                    confirm = await onItemDeleteConfirm();
                  }
                  return confirm;
                },
                child: ListTile(
                  title: Text(item.name),
                  subtitle: addedDateBuilder?.call(item),
                  leading: Image.network(item.imageUrl),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: item.isFavorite ?Colors.amber : null),
                    onPressed: () {
                      onItemFavoritesEvent(category, item);
                    },
                  ),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    onItemDelete(category, item);
                  } else {
                    onItemFavoritesEvent(category, item);
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
