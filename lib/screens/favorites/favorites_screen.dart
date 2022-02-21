import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      appBarTitle: "Favorites",
      body: Center(
        child: Text("Favorites Screen"),
      ),
    );
  }
}
