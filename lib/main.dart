import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:ct_shopping_list_challenge/config/config.locator.dart';
import 'package:ct_shopping_list_challenge/firebase_options.dart';

import 'package:ct_shopping_list_challenge/screens/core/app_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInitConfigurations();
  runApp(const AppScreen());
}

Future<void> setupInitConfigurations() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
}
