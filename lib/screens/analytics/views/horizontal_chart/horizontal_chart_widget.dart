import 'dart:math';
import 'package:flutter/material.dart';
import 'package:izowork/screens/analytics/views/horizontal_chart/horizontal_chart_list_item_widget.dart';

class HorizontalChartWidget extends StatefulWidget {
  final VoidCallback onMaxScrollExtent;

  const HorizontalChartWidget({Key? key, required this.onMaxScrollExtent})
      : super(key: key);

  @override
  _HorizontalChartState createState() => _HorizontalChartState();
}

class _HorizontalChartState extends State<HorizontalChartWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<double> _values = [];

  double _maxValue = 0.0;

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      _values.add(Random().nextDouble() * 1500);
    }

    for (var element in _values) {
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

    return SizedBox(
        height: _maxHeight * 1.5,
        child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _values.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Align(
                  alignment: Alignment.bottomCenter,
                  child: HorizontalChartListItemWidget(
                    index: index,
                    maxHeight: _maxHeight,
                    height: (_maxHeight / _maxValue) * _values[index],
                    value: _values[index],
                    dateTime: DateTime.now().add(Duration(days: index)),
                  ));
            }));
  }
}
