import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/utils/constants.dart' as constants;

import 'package:ct_shopping_list_challenge/screens/favorites/favorites_screen.dart';
import 'package:ct_shopping_list_challenge/screens/item_and_category/create_item_and_category_screen.dart';
import 'package:ct_shopping_list_challenge/screens/shopping_list/shopping_list_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: constants.backgroundColor,
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: constants.primaryColor,
            ),
            child: Text("Shopping List", style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),),
          ),
          ListTile(
            title: const Text("Shopping List"),
            onTap: () => navigateToScreen(context, const ShoppingListScreen()),
          ),
          ListTile(
            title: const Text("Create Item / Category"),
            onTap: () => navigateToScreen(context, const CreateItemAndCategoryScreen()),
          ),
          ListTile(
            title: const Text("Favorites"),
            onTap: () => navigateToScreen(context, const FavoritesScreen()),
          ),
        ],
      ),
    );
  }

  void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => screen),
    );
  }

}
