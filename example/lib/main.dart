import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfect_keyboard/perfect_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfect Keyboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SuperKeyboard(),
    );
  }
}

class SuperKeyboard extends StatefulWidget {
  const SuperKeyboard({super.key});

  @override
  State<SuperKeyboard> createState() => _SuperKeyboardState();
}

class _SuperKeyboardState extends State<SuperKeyboard>
    with SingleTickerProviderStateMixin {
  List<String> specialKey = [];
  List<Locale> supportedLocales = const [
    Locale('tr'),
    Locale('kk'),
    Locale('ar'),
    Locale('de'),
    Locale('ru'),
  ];
  int index = 0;
  late AnimationController _controller;
  late Animation<Color> _colorAnimation;
  final List<Color> _colors = [
    Colors.lime,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.blue,
    Colors.yellow,
  ];
  ValueNotifier<List<int>> highLightedKeyPosition = ValueNotifier([-1, -1]);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTweenSequence(_colors).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    highLightedKeyPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text("Super Keyboard"),
        ),
        body: FutureBuilder(
          future: getKeyboard(locale: supportedLocales[index]),
          builder: (BuildContext context,
              AsyncSnapshot<List<List<SuperKeyboardKey>>> snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              final maxKeys = data.fold<int>(
                  0, (max, item) => item.length > max ? item.length : max);
              final baseWidth = screenWidth / maxKeys;

              List<Widget> columnChildren = data.map((entry) {
                int specialKeysCount = entry.where((button) {
                  return button.isSpecial;
                }).length;
                double standardWidth = baseWidth - 1;
                double gaps = entry.length * 0.5;
                double extraWidth =
                    screenWidth - (entry.length * standardWidth) - gaps;
                double extraWidthPerSpecialKey =
                    specialKeysCount > 0 ? extraWidth / specialKeysCount : 0;
                List<Widget> rowChildren = entry.map<Widget>((button) {
                  double keyWidth = button.isSpecial
                      ? standardWidth + extraWidthPerSpecialKey
                      : standardWidth;
                  return KeyWidget(
                    keyboardKey: button,
                    width: keyWidth,
                    colorAnimation: _colorAnimation,
                    onSpecialKeyChanged: (List<String> keys) {
                      setState(() {
                        specialKey = keys;
                      });
                    },
                    onIndexChanged: (int newIndex) {
                      setState(() {
                        index = newIndex;
                      });
                    },
                    highLightedKeyPosition: highLightedKeyPosition,
                  );
                }).toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowChildren,
                );
              }).toList();

              return SizedBox(
                width: screenWidth,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: columnChildren,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class KeyWidget extends StatefulWidget {
  final SuperKeyboardKey keyboardKey;
  final double width;
  final Animation<Color> colorAnimation;
  final Function(List<String>) onSpecialKeyChanged;
  final Function(int) onIndexChanged;
  final KeyWidget? nextKeyWidget;
  final KeyWidget? previousKeyWidget;
  final KeyWidget? topKeyWidget;
  final KeyWidget? bottomKeyWidget;
  final ValueNotifier<List<int>> highLightedKeyPosition;

  const KeyWidget({
    super.key,
    required this.keyboardKey,
    required this.width,
    required this.colorAnimation,
    required this.onSpecialKeyChanged,
    required this.onIndexChanged,
    this.nextKeyWidget,
    this.previousKeyWidget,
    this.topKeyWidget,
    this.bottomKeyWidget,
    required this.highLightedKeyPosition,
  });

  @override
  State<KeyWidget> createState() => _KeyWidgetState();
}

class _KeyWidgetState extends State<KeyWidget> {
  List<String> specialKey = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final keyLabel = widget.keyboardKey.value;

    return GestureDetector(
      onLongPressStart: (details) {
        setState(() {
          specialKey.add(keyLabel.toLowerCase());
        });
        widget.onSpecialKeyChanged(specialKey);
      },
      onLongPressEnd: (details) {
        setState(() {
          specialKey.clear();
        });
        widget.onSpecialKeyChanged(specialKey);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (keyLabel == 'Space') {
          if (details.velocity.pixelsPerSecond.dx > 500) {
            setState(() {
              index = (index + 1) % 5;
              widget.onIndexChanged(index);
            });
          } else if (details.velocity.pixelsPerSecond.dx < -500) {
            setState(() {
              index = (index - 1 + 6) % 5;
              widget.onIndexChanged(index);
            });
          }
        }
      },
      child: InkWell(
        onTap: () async {
          if (specialKey.isNotEmpty) {
            print(
                "${specialKey.map((element) => '$element+').toString().replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').replaceAll(',', '')}$keyLabel");
          } else {
            print(keyLabel);
          }
          await animateKey();
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.25, right: 0.25),
          child: AnimatedBuilder(
              animation: widget.colorAnimation,
              builder: (context, child) {
                return ValueListenableBuilder(
                  builder: (context, val, child) {
                    return Ink(
                      width: widget.width - 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: widget.colorAnimation.value.withAlpha(100),
                              blurRadius: 20.0,
                              spreadRadius: 10.0,
                              offset: const Offset(0, 5)),
                        ],
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.75),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                        border: Border.all(
                          color: val.first == widget.keyboardKey.rowIndex &&
                                  val.last == widget.keyboardKey.columnIndex
                              ? Colors.white
                              : widget.colorAnimation.value,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (widget.keyboardKey.shiftKey != null)
                            Positioned(
                              top: 5,
                              left: 8,
                              child: Text(
                                widget.keyboardKey.shiftKey!,
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.white),
                                maxLines: 1,
                              ),
                            ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Builder(builder: (context) {
                                if (keyLabel == 'Space') {
                                  return const Icon(
                                    Icons.space_bar,
                                    color: Colors.white,
                                  );
                                } else if (keyLabel == 'Tab') {
                                  return const Icon(
                                    Icons.keyboard_tab,
                                    color: Colors.white,
                                  );
                                } else if (keyLabel == 'Backspace') {
                                  return const Icon(
                                    Icons.keyboard_backspace,
                                    color: Colors.white,
                                  );
                                } else if (keyLabel == 'Enter') {
                                  return const Icon(
                                    Icons.keyboard_return,
                                    color: Colors.white,
                                  );
                                } else if (keyLabel == 'Win') {
                                  return const Icon(
                                    Icons.window_sharp,
                                    color: Colors.white,
                                  );
                                } else if (keyLabel == 'Menu') {
                                  return const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  );
                                } else {
                                  return Text(
                                    keyLabel,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  );
                                }
                              }),
                            ),
                          ),
                          if (widget.keyboardKey.altGrKey != null)
                            Positioned(
                              bottom: 5,
                              right: 8,
                              child: Text(
                                widget.keyboardKey.altGrKey!,
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.white),
                                maxLines: 1,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  valueListenable: widget.highLightedKeyPosition,
                );
              }),
        ),
      ),
    );
  }
  Future<void> animateKey() async {
    SuperKeyboardKey currentKey = widget.keyboardKey;
    while (currentKey.nextKey != null) {
      currentKey = currentKey.nextKey!;
      widget.highLightedKeyPosition.value = [
        currentKey.rowIndex,
        currentKey.columnIndex
      ];
      await Future.delayed(const Duration(milliseconds: 50));
    }
    widget.highLightedKeyPosition.value = [-1, -1];
  }
}

class ColorTweenSequence extends Animatable<Color> {
  final List<Color> colors;

  ColorTweenSequence(this.colors);

  @override
  Color transform(double t) {
    final int index = (t * (colors.length - 1)).toInt();
    final Color startColor = colors[index];
    final Color endColor = colors[(index + 1) % colors.length];
    final double localT = (t * (colors.length - 1)) - index;

    return Color.lerp(startColor, endColor, localT) ?? startColor;
  }
}
