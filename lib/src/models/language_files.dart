/// Represents the language files used in the application.
///
/// Each enum value corresponds to a specific language and the associated
/// JSON file that contains the keyboard layout for that language.
enum LanguageFiles {
  /// The JSON file for the Turkish keyboard layout.
  turkish('turkish.json'),

  /// The JSON file for the Arabic keyboard layout.
  arabic('arabic.json'),

  /// The JSON file for the Russian keyboard layout.
  russian('russian.json'),

  /// The JSON file for the German keyboard layout.
  german('german.json'),

  /// The JSON file for the Kazakh keyboard layout.
  kazakh('kazakh.json');

  /// The name of the JSON file containing the keyboard layout.
  final String fileName;

  /// Creates a [LanguageFiles] enum value with the given [fileName].
  const LanguageFiles(this.fileName);
}
