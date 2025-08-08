import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:myuniplanner/pages/mainscreen.dart';
import 'package:myuniplanner/providers/providers.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(800, 500));
    await windowManager.show();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Telas()),
        ChangeNotifierProvider(create: (_) => Temas()),
      ],
      child: MyApp(),
    ),
  );
}

