import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_wat/scrollable_wat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScrollableExample(),
    );
  }
}

class ScrollableExample extends StatefulWidget {
  const ScrollableExample({super.key});

  @override
  State<ScrollableExample> createState() => _ScrollableExampleState();
}

class _ScrollableExampleState extends State<ScrollableExample> {
  int numberOfItems = 100;

  double minimumPercentage = 20.0;

  late List<Color> itemColors;

  var randomMax = 1 << 32;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final colorGenerator = Random(42490823);
    itemColors = List<Color>.generate(
      numberOfItems,
      (int _) => Color(colorGenerator.nextInt(randomMax)).withOpacity(1),
    );
  }

  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Controller to scroll a certain number of pixels relative to the current
  /// scroll offset.
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ScrollableWat.builder(
        itemCount: numberOfItems,
        itemBuilder: (context, index) {
          var size = MediaQuery.of(context).size;
          return SizedBox(
            height: size.height,
            width: size.width,
            child: Container(
              color: itemColors[index],
              child: Center(
                child: Text('Item $index'),
              ),
            ),
          );
        },
        minimumPercentage: minimumPercentage,
        scrollDuration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
  }
}
