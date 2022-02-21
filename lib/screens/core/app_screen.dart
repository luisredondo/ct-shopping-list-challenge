import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/screens/main/main_page_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      home: MainPageScreen(),
    );
  }
}
