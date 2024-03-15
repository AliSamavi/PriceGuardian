import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Localization {
  static const delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static const supported = [Locale("fa")];
}
