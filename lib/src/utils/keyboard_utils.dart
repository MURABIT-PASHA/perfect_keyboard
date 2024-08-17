import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:perfect_keyboard/perfect_keyboard.dart';

/// Loads the keyboard layout from a JSON file corresponding to the given language name.
Future<List<List<SuperKeyboardKey>>> _loadKeyboard({required String langName}) async {
  final String body = await rootBundle.loadString('packages/perfect_keyboard/lib/assets/$langName.json');
  List<List<SuperKeyboardKey>> lineKeys = [];
  final Map<String, dynamic> decodedBody = json.decode(body) as Map<String, dynamic>;

  for (final String lineNumber in decodedBody.keys) {
    SuperKeyboardKey? currentKey;
    int columnIndex = 0;
    List<SuperKeyboardKey> keys = [];

    for (final Map<String, dynamic> keyValue in decodedBody[lineNumber]) {
      final String key = keyValue.keys.first;
      final Map<String, dynamic>? innerMap = keyValue[key] as Map<String, dynamic>?;

      final String? altGrKey = innerMap?['alt_gr'] as String?;
      final String? shiftKey = innerMap?['shift'] as String?;

      final SuperKeyboardKey keyboardKey = SuperKeyboardKey(
        rowIndex: int.parse(lineNumber),
        columnIndex: columnIndex,
        value: key,
        isSpecial: _isSpecialKey(key),
        previousKey: currentKey,
        nextKey: null,
        topKey: lineKeys.isNotEmpty ? lineKeys.last[columnIndex] : null,
        bottomKey: null,
        altGrKey: altGrKey,
        shiftKey: shiftKey,
      );

      if (currentKey != null) {
        currentKey.nextKey = keyboardKey;
      }

      if (lineKeys.isNotEmpty && columnIndex < lineKeys.last.length) {
        lineKeys.last[columnIndex].bottomKey = keyboardKey;
      }

      keys.add(keyboardKey);
      currentKey = keyboardKey;
      columnIndex += 1;
    }

    lineKeys.add(keys);
  }

  return lineKeys;
}

/// Returns the keyboard layout for the given locale.
Future<List<List<SuperKeyboardKey>>> getKeyboard({required Locale locale}) {
  final languageFile = _handleLanguage(locale: locale);
  if (languageFile == null) {
    throw Exception('Unsupported language: ${locale.languageCode}');
  } else {
    return _loadKeyboard(langName: languageFile.name);
  }
}

/// Maps the locale to the corresponding language file.
LanguageFiles? _handleLanguage({required Locale locale}) {
  switch (locale.languageCode) {
    case 'tr':
      return LanguageFiles.turkish;
    case 'ar':
      return LanguageFiles.arabic;
    case 'ru':
      return LanguageFiles.russian;
    case 'de':
      return LanguageFiles.german;
    case 'kk':
      return LanguageFiles.kazakh;
    default:
      return null;
  }
}

/// Checks if the given key label corresponds to a special key.
bool _isSpecialKey(String keyLabel) {
  return SpecialKeys.values.any((key) => key.keyValue == keyLabel);
}
