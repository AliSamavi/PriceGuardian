import 'package:PriceGuardian/Core/Constants/localization.dart';
import 'package:PriceGuardian/Core/Themes/themes.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StoreModelAdapter());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: Localization.delegates,
      supportedLocales: Localization.supported,
      theme: Themes.primary,
      home: const Scaffold(
        body: Center(
          child: Text('سلام جهان!'),
        ),
      ),
    );
  }
}
