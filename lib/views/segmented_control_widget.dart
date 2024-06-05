import 'package:flutter/material.dart';

class SegmentedControlWidget extends StatefulWidget {
  final List<String> titles;
  final int? initialIndex;
  final double? width;
  final double? margin;
  final Color activeColor;
  final Color disableColor;
  final Color backgroundColor;
  final Color thumbColor;
  final Color? borderColor;

  final void Function(int) onTap;

  const SegmentedControlWidget({
    Key? key,
    required this.titles,
    this.initialIndex,
    this.width,
    this.margin,
    required this.onTap,
    required this.activeColor,
    required this.disableColor,
    required this.backgroundColor,
    required this.thumbColor,
    this.borderColor,
  }) : super(key: key);

  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControlWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.initialIndex ?? _selectedIndex;

    const _borderWidth = 1.0;
    const _padding = 4.0;
    final _lenght = widget.titles.length;
    final _margin = widget.margin == null ? 16.0 : widget.margin!;
    final _width = widget.width == null
        ? MediaQuery.of(context).size.width - _margin * 2.0
        : widget.width! - _margin * 2.0;

    final _segmentedWidth =
        (_width - _borderWidth * 2 - _padding * 2.0) / _lenght;

    return Container(
      padding: const EdgeInsets.all(4.0),
      width: _width,
      height: 40.0,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          width: widget.borderColor == null ? 0.0 : 1.0,
          color: widget.borderColor == null
              ? Colors.transparent
              : widget.borderColor!,
        ),
      ),
      child: Stack(children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _segmentedWidth * _selectedIndex,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0)),
            ),
            Container(
              width: _segmentedWidth,
              decoration: BoxDecoration(
                color: widget.thumbColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
            )
          ],
        ),
        ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: widget.titles.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {
                  setState(() => _selectedIndex = index),
                  widget.onTap(index)
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: _segmentedWidth,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.titles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: index == _selectedIndex
                              ? widget.activeColor
                              : widget.disableColor,
                        ),
                      ),
                    )
                  ]),
                ),
              );
            })
      ]),
    );
  }
}
