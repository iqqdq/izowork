import 'package:flutter/material.dart';
import 'package:izowork/features/analytics/view/views/horizontal_chart/horizontal_chart_list_item_widget.dart';

class HorizontalChartWidget extends StatefulWidget {
  final List<String> labels;
  final List<int> values;
  final VoidCallback onMaxScrollExtent;

  const HorizontalChartWidget(
      {Key? key,
      required this.labels,
      required this.values,
      required this.onMaxScrollExtent})
      : super(key: key);

  @override
  _HorizontalChartState createState() => _HorizontalChartState();
}

class _HorizontalChartState extends State<HorizontalChartWidget> {
  final ScrollController _scrollController = ScrollController();

  int _maxValue = 0;

  @override
  void initState() {
    for (var element in widget.values) {
      if (element > _maxValue) {
        _maxValue = element;
      }
    }

    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onMaxScrollExtent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _maxHeight = 112.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _maxHeight * 1.5,
      child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: widget.values.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Align(
                key: ValueKey(widget.values[index]),
                alignment: Alignment.bottomCenter,
                child: HorizontalChartListItemWidget(
                  index: index,
                  maxHeight: _maxHeight,
                  height: (_maxHeight / _maxValue) * widget.values[index],
                  value: widget.values[index],
                  month: widget.labels[index],
                ));
          }),
    );
  }
}
