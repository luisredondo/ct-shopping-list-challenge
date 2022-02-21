import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';
import 'package:ct_shopping_list_challenge/screens/shopping_list/shopping_list_screen.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      body: ShoppingListScreen(),
    );
  }

}
