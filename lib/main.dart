import 'package:PriceGuardian/Core/Constants/localization.dart';
import 'package:PriceGuardian/Core/Themes/themes.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:PriceGuardian/Features/Views/login.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StoreModelAdapter());
  await GetStorage.init();
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
      home: GetStorage().read("data") == null
          ? const LoginView()
          : const Scaffold(),
    );
  }
}
