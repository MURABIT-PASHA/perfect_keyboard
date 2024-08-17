## 0.0.1

### Initial Release

#### Features

1. **Keyboard Management**
    - `SuperKeyboardKey`: A comprehensive class representing a keyboard key with properties for value, position, special keys (shift, altGr), and neighboring keys (next, previous, top, bottom).
    - `LanguageFiles` Enum: Maps supported languages to their respective JSON files for keyboard layouts.
    - `SpecialKeys` Enum: Defines special keyboard keys (Space, Tab, Backspace, Caps Lock, Shift, Enter, Win, Menu) with their string representations.

2. **JSON-based Keyboard Layout Loading**
    - `_loadKeyboard`: Asynchronously loads keyboard layouts from JSON files, establishing the relationships between keys and their neighbors.
    - `getKeyboard`: Retrieves the keyboard layout for a given locale using the `LanguageFiles` enum.
    - `_handleLanguage`: Maps locale to corresponding language file.
    - `_isSpecialKey`: Checks if a given key label corresponds to a special key defined in the `SpecialKeys` enum.


#### Improvements

- Ensured seamless integration of custom themes and color schemes within Flutter applications.
- Provided extensive support for various keyboard layouts based on different languages, enabling easy localization.
- Enhanced keyboard interaction with detailed key relationships and animation effects.

#### Bug Fixes

- Fixed issues related to custom color visibility across light and dark themes.
- Corrected key relationship mappings to ensure accurate neighboring key references in `SuperKeyboardKey`.

This initial release sets the foundation for robust theme customization and keyboard management in Flutter applications, with a focus on flexibility and localization support.
