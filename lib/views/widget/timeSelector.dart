import 'package:flutter/material.dart';
import 'package:jellyjelly/utils/colors.dart';
import 'package:jellyjelly/utils/fonts.dart';

class HorizontalWheelSelector extends StatefulWidget {
  final List<int> items;
  final ValueChanged<int> onSelected;

  const HorizontalWheelSelector({
    super.key,
    required this.items,
    required this.onSelected,
  });

  @override
  State<HorizontalWheelSelector> createState() => _HorizontalWheelSelectorState();
}

class _HorizontalWheelSelectorState extends State<HorizontalWheelSelector> {
  late FixedExtentScrollController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: 2
    );
    _selectedIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: RotatedBox(
        quarterTurns: -1,
        child: ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 45,
          diameterRatio: 2,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            widget.onSelected(widget.items[index]);
            setState(() {
              _selectedIndex = index;
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              if (index < 0 || index >= widget.items.length) return null;
              return RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: Text(
                    "${widget.items[index]} s",
                    style: TextStyle(
                        fontSize: 16 ,
                        color: index == _selectedIndex ?  Colors.white : CustomColors.white_20,
                        fontFamily: CustomFonts.titiliumWeb_Bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
