# Perfect Keyboard

The Perfect Keyboard package provides a customizable and interactive keyboard layout for Flutter applications. It includes support for multiple languages and advanced key management features, allowing developers to create dynamic and localized keyboard experiences.

## Features

  <style>
    .container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px;
    }
    .image {
      flex: 1;
      max-width: 50%;
    }
    .features {
      flex: 1;
      max-width: 50%;
      padding-left: 20px;
    }
    .features ul {
      list-style-type: disc;
      padding-left: 20px;
    }
  </style>
<body>
  <div class="container">
    <div class="image">
      <img src="https://github.com/MURABIT-PASHA/Images/raw/main/keyboard.gif" alt="Flutter App Demo" width="600" height="250">
    </div>
    <div class="features">
      <ul>
        <li><strong>Advanced Keyboard Management</strong>: Utilize <code>SuperKeyboardKey</code> to manage key properties and relationships.</li>
        <li><strong>Multi-language Support</strong>: Easily switch between keyboard layouts for different languages using JSON files.</li>
        <li><strong>Special Key Handling</strong>: Includes support for special keys such as Space, Tab, Backspace, and more via the <code>SpecialKeys</code> enum.</li>
      </ul>
    </div>
  </div>
</body>

## Getting Started

1. Add `perfect_keyboard` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     perfect_keyboard: ^0.0.1
   ```
2. Install the package:
    ```shell
    flutter pub get
    ```
3. Import and use the package in your Flutter project:

    ```dart
    import 'package:perfect_keyboard/perfect_keyboard.dart';
    ```

## Supported Languages
    Turkish,
    Kazakh,
    Russian,
    Arabic,
    German

**For detailed usage and customization options, please check out example.**

## Additional Information
   * **Contributing:** We welcome contributions! Please refer to the contributing guide for information on how to contribute.
   * **Issues:** If you encounter any issues, please file them in the issues tracker.
   * **Contact:** For any questions or feedback, you can reach out to the maintainer at akdoganmurabit@gmail.com.

__Thank you for using Perfect Keyboard!__