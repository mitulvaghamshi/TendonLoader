import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    Key? key,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 60,
    this.itemCount = 3,
    this.step = 1,
    this.itemHeight = 50,
    this.itemWidth = 80,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = true,
    this.decoration,
    this.zeroPad = false,
  })  : assert(minValue <= value),
        assert(value <= maxValue),
        super(key: key);

  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final int itemCount;
  final int step;
  final double itemHeight;
  final double itemWidth;
  final Axis axis;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final bool haptics;
  final bool zeroPad;
  final Decoration? decoration;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final double initialOffset = (widget.value - widget.minValue) ~/ widget.step * itemExtent;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    int indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    final int intValueInTheMiddle = _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);
    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) {
        HapticFeedback.selectionClick();
      }
    }
    Future<void>.delayed(const Duration(milliseconds: 100), () => _maybeCenterValue());
  }

  @override
  void didUpdateWidget(TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;
  double get itemExtent => widget.axis == Axis.vertical ? widget.itemHeight : widget.itemWidth;
  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;
  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;
  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.axis == Axis.vertical ? widget.itemWidth : widget.itemCount * widget.itemWidth,
      height: widget.axis == Axis.vertical ? widget.itemCount * widget.itemHeight : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollEndNotification not) {
          if (not.dragDetails?.primaryVelocity == 0) Future<void>.microtask(() => _maybeCenterValue());
          return true;
        },
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: listItemsCount,
              scrollDirection: widget.axis,
              controller: _scrollController,
              itemExtent: itemExtent,
              itemBuilder: _itemBuilder,
              padding: EdgeInsets.zero,
            ),
            _NumberPickerSelectedItemDecoration(
              axis: widget.axis,
              itemExtent: itemExtent,
              decoration: widget.decoration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle? defaultStyle = widget.textStyle ?? themeData.textTheme.bodyText2;
    final TextStyle? selectedStyle =
        widget.selectedTextStyle ?? themeData.textTheme.headline5?.copyWith(color: themeData.accentColor);
    final int value = _intValueFromIndex(index % itemCount);
    final bool isExtra = index < additionalItemsOnEachSide || index >= listItemsCount - additionalItemsOnEachSide;
    final TextStyle? itemStyle = value == widget.value ? selectedStyle : defaultStyle;
    final Widget child = isExtra ? const SizedBox.shrink() : Text(_getDisplayedValue(value), style: itemStyle);
    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      alignment: Alignment.center,
      child: child,
    );
  }

  String _getDisplayedValue(int value) =>
      widget.zeroPad ? value.toString().padLeft(widget.maxValue.toString().length, '0') : value.toString();

  int _intValueFromIndex(int index) {
    index -= additionalItemsOnEachSide;
    index %= itemCount;
    return widget.minValue + index * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      final int diff = widget.value - widget.minValue;
      final int index = diff ~/ widget.step;
      _scrollController.animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  const _NumberPickerSelectedItemDecoration({
    Key? key,
    required this.axis,
    required this.itemExtent,
    required this.decoration,
  }) : super(key: key);

  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}
