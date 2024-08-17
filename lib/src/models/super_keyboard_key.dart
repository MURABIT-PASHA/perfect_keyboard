/// Represents a key on the keyboard, including its position and special attributes.
class SuperKeyboardKey {
  /// The label or value of the key.
  final String value;

  /// The column index of the key in the keyboard layout.
  final int columnIndex;

  /// The row index of the key in the keyboard layout.
  final int rowIndex;

  /// Indicates if the key is a special key (e.g., Shift, Enter).
  final bool isSpecial;

  /// The label or value of the key when the Shift key is pressed.
  final String? shiftKey;

  /// The label or value of the key when the AltGr key is pressed.
  final String? altGrKey;

  /// The key to the right of the current key.
  SuperKeyboardKey? nextKey;

  /// The key to the left of the current key.
  SuperKeyboardKey? previousKey;

  /// The key above the current key.
  SuperKeyboardKey? topKey;

  /// The key below the current key.
  SuperKeyboardKey? bottomKey;

  /// Creates a [SuperKeyboardKey] instance with the given properties.
  SuperKeyboardKey({
    required this.value,
    required this.columnIndex,
    required this.rowIndex,
    required this.isSpecial,
    this.shiftKey,
    this.altGrKey,
    this.nextKey,
    this.previousKey,
    this.topKey,
    this.bottomKey,
  });
}
