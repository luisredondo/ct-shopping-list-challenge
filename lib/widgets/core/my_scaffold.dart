import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/utils/constants.dart' as constants;

import 'package:ct_shopping_list_challenge/widgets/core/my_drawer.dart';

class MyScaffold extends StatelessWidget {

  const MyScaffold({ 
    Key? key,
    required this.body,
    this.appBarTitle,
    this.appBarActions,
  }) : super(key: key);

  final Widget body;
  final String? appBarTitle;
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: appBarTitle != null ? AppBar(
        backgroundColor: constants.primaryColor,
        title: Text(appBarTitle!),
        actions: appBarActions,
      ) : null,
      drawer: const MyDrawer(),
      body: body,
    );
  }
}
