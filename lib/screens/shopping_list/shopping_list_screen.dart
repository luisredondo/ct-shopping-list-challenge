import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';

import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';
import 'package:ct_shopping_list_challenge/utils/pastel_color_generator.dart';
import 'package:ct_shopping_list_challenge/widgets/shopping_list/category_expandable_container.dart';

class ShoppingListScreen extends StatelessWidget {

  const ShoppingListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Category> shoppingCategories = [
      Category(name: 'Groceries', color: generatePastelColor()),
      Category(name: 'Clothes', color: generatePastelColor()),
      Category(name: 'Electronics', color: generatePastelColor()),
      Category(name: 'Other', color: generatePastelColor()),
    ];
    final List<Item> shoppingItems = [
      const Item(name: 'Milk', category: 'Groceries', image: "https://picsum.photos/200"),
      const Item(name: 'Eggs', category: 'Groceries', image: "https://picsum.photos/200"),
      const Item(name: 'Bread', category: 'Groceries', image: "https://picsum.photos/200"),
      const Item(name: 'Coffee', category: 'Groceries', image: "https://picsum.photos/200"),
      const Item(name: 'T-Shirt', category: 'Clothes', image: "https://picsum.photos/200"),
      const Item(name: 'Shorts', category: 'Clothes', image: "https://picsum.photos/200"),
      const Item(name: 'Socks', category: 'Clothes', image: "https://picsum.photos/200"),
      const Item(name: 'iPhone', category: 'Electronics', image: "https://picsum.photos/200"),
      const Item(name: 'iPad', category: 'Electronics', image: "https://picsum.photos/200"),
      const Item(name: 'iMac', category: 'Electronics', image: "https://picsum.photos/200"),
      const Item(name: 'iWatch', category: 'Other', image: "https://picsum.photos/200"),
      const Item(name: 'iPod', category: 'Other', image: "https://picsum.photos/200"),
      const Item(name: 'iPod Nano', category: 'Other', image: "https://picsum.photos/200"),
    ];
    final size = MediaQuery.of(context).size;
    return MyScaffold(
      appBarTitle: "Shopping List",
      body: ListView.builder(
        padding: EdgeInsets.only(
          bottom: size.height * 0.1,
        ),
        itemCount: shoppingCategories.length,
        itemBuilder: (context, index) {
          final category = shoppingCategories[index];
          final List<Item> itemsForCategory = shoppingItems.where((Item item) => item.category == category.name).toList();
          return CategoryExpandableContainer(
            category: category, 
            items: itemsForCategory,
            onCategoryDelete: (_) => print('Category deleted'),
            onItemDelete: (_) => print('Item deleted'),
            onItemAddToFavorites: (_) => print("Add to favorites"),
          );
        },
      ),
    );
  }

}
