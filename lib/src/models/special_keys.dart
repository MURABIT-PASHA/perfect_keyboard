/// Represents special keys used in the keyboard layout.
///
/// Each enum value corresponds to a specific special key and its label.
enum SpecialKeys {
  /// The space key.
  space('Space'),

  /// The tab key.
  tab('Tab'),

  /// The backspace key.
  backspace('Backspace'),

  /// The caps lock key.
  capslock('Caps Lock'),

  /// The shift key.
  shift('Shift'),

  /// The enter key.
  enter('Enter');

  /// The label of the special key.
  final String keyValue;

  /// Creates a [SpecialKeys] enum value with the given [keyValue].
  const SpecialKeys(this.keyValue);
}
