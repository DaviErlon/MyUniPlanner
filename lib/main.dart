import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:myuniplanner/screens/mainscreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(800, 500));
    await windowManager.show();
  });

  runApp(const MyApp());
}

