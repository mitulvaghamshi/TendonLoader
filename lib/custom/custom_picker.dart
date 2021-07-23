import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomPicker extends StatefulWidget {
  const CustomPicker({Key? key, required this.onChanged}) : super(key: key);

  final ValueChanged<int> onChanged;

  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return _NumberPicker(value: value, onChanged: (int val) => setState(() => widget.onChanged(value = val)));
  }
}

/// Extracted from Flutter samples repository.
class _NumberPicker extends StatefulWidget {
  const _NumberPicker({
    Key? key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.minValue = 0,
    this.maxValue = 60,
    this.itemCount = 3,
    this.itemWidth = 80,
    this.itemHeight = 50,
    Axis axis = Axis.vertical,
  })  : assert(minValue <= value && value <= maxValue),
        isVertical = axis == Axis.vertical,
        super(key: key);

  final int step;
  final int value;
  final int minValue;
  final int maxValue;
  final int itemCount;
  final bool isVertical;
  final double itemWidth;
  final double itemHeight;
  final ValueChanged<int> onChanged;

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<_NumberPicker> {
  late final ScrollController _scrollCtrl =
      ScrollController(initialScrollOffset: (widget.value - widget.minValue) ~/ widget.step * itemExtent)
        ..addListener(_scrollListener);

  @override
  void didUpdateWidget(_NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _maybeCenterValue();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final int intValueInTheMiddle = _intValueFromIndex(
        ((_scrollCtrl.offset / itemExtent).round()).clamp(0, itemCount - 1) + additionalItemsOnEachSide);
    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      HapticFeedback.vibrate();
    }
    Future<void>.delayed(const Duration(milliseconds: 100), _maybeCenterValue);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final ThemeData themeData = Theme.of(context);
    final int value = _intValueFromIndex(index % itemCount);
    final bool isExtra = index < additionalItemsOnEachSide || index >= listItemsCount - additionalItemsOnEachSide;
    final TextStyle? itemStyle =
        value == widget.value ? const TextStyle(fontSize: 32, color: colorGoogleGreen) : themeData.textTheme.bodyText2;
    final Widget child = isExtra ? const SizedBox.shrink() : Text(value.toString(), style: itemStyle);
    return Container(width: widget.itemWidth, height: widget.itemHeight, alignment: Alignment.center, child: child);
  }

  int _intValueFromIndex(int index) =>
      widget.minValue + ((index - additionalItemsOnEachSide) % itemCount) * widget.step;

  void _maybeCenterValue() {
    if (_scrollCtrl.hasClients && !isScrolling) {
      _scrollCtrl.animateTo(
        ((widget.value - widget.minValue) ~/ widget.step) * itemExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;
  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;
  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;
  bool get isScrolling => _scrollCtrl.position.isScrollingNotifier.value;
  double get itemExtent => widget.isVertical ? widget.itemHeight : widget.itemWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isVertical ? widget.itemWidth : widget.itemCount * widget.itemWidth,
      height: widget.isVertical ? widget.itemCount * widget.itemHeight : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollEndNotification not) {
          if (not.dragDetails?.primaryVelocity == 0) Future<void>.microtask(_maybeCenterValue);
          return true;
        },
        child: Stack(children: <Widget>[
          ListView.builder(
            padding: EdgeInsets.zero,
            itemExtent: itemExtent,
            itemCount: listItemsCount,
            itemBuilder: _itemBuilder,
            controller: _scrollCtrl,
            scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
          ),
          _SelectedItemDecoration(isVertical: widget.isVertical, itemExtent: itemExtent),
        ]),
      ),
    );
  }
}

class _SelectedItemDecoration extends StatelessWidget {
  const _SelectedItemDecoration({Key? key, required this.isVertical, required this.itemExtent}) : super(key: key);

  final bool isVertical;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 3, color: Theme.of(context).primaryColor),
          ),
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
        ),
      ),
    );
  }
}
