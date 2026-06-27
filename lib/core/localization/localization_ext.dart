import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension LocalizationExt on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
