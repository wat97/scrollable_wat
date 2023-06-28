import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// ignore: depend_on_referenced_packages
import 'package:visibility_detector/visibility_detector.dart';

class ScrollableWat extends StatefulWidget {
  const ScrollableWat.builder({
    required this.itemCount,
    required this.itemBuilder,
    required this.minimumPercentage,
    this.shrinkWrap = false,
    Key? key,
    this.physics,
    this.padding,
    this.scrollDirection = Axis.vertical,
    Duration? scrollDuration,
  })  : scrollDuration = scrollDuration ?? const Duration(milliseconds: 200),
        super(key: key);

  /// Number of items the [itemBuilder] can produce.
  final int itemCount;

  /// Called to build children for the list with
  /// 0 <= index < itemCount.
  final IndexedWidgetBuilder itemBuilder;

  /// {@template scrollable_wat.scroll_view.shrinkWrap}
  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  ///  Defaults to false.
  ///
  /// See [ScrollView.shrinkWrap].
  final bool shrinkWrap;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// See [ScrollView.physics].
  final ScrollPhysics? physics;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// The amount of space by which to inset the children.
  final EdgeInsets? padding;

  /// The amount of how long scoll to next or prev
  final Duration scrollDuration;

  final double minimumPercentage;

  @override
  State<ScrollableWat> createState() => _ScrollableWatState();
}

class _ScrollableWatState extends State<ScrollableWat> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Controller to scroll a certain number of pixels relative to the current
  /// scroll offset.
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool isScroll = false;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.itemCount,
      // itemBuilder: widget.itemBuilder,
      itemBuilder: (context, index) {
        return VisibilityDetector(
          key: Key("$index"),
          onVisibilityChanged: (info) {
            var infoPercentage = (info.visibleFraction * 100).ceil();
            ItemPosition position =
                itemPositionsListener.itemPositions.value.first;
            if (index != position.index) {
              if (infoPercentage < widget.minimumPercentage) {
                if (!isScroll) {
                  isScroll = true;
                  int added = 0;
                  if (itemScrollController.scrolling == Scrolling.ScrollDown) {
                    added++;
                  } else if (itemScrollController.scrolling ==
                      Scrolling.ScrollUp) {
                    added--;
                  }
                  itemScrollController
                      .scrollTo(
                        index: (position.index + added),
                        duration: widget.scrollDuration,
                      )
                      .then((value) => isScroll = false);
                }
              }
            }
          },
          child: widget.itemBuilder(context, index),
        );
        // return widget.itemBuilder(context, index);
      },
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetController: scrollOffsetController,
      scrollDirection: widget.scrollDirection,
    );
  }
}
