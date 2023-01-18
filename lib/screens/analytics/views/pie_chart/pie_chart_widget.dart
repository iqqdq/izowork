import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class PieChartModel {
  final String name;
  final Color color;
  final double value;

  PieChartModel(this.name, this.color, this.value);
}

class PieChartWidget extends StatefulWidget {
  final List<PieChartModel> items;

  const PieChartWidget({Key? key, required this.items}) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChartWidget> {
  final List<PieChartSectionData> _sections = [];
  final List<Widget> _titles = [];
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();

    _getSections();
    _getTitles();
  }

  Future _getSections() async {
    setState(() {
      for (var element in widget.items) {
        _sections.add(PieChartSectionData(
            color: element.color,
            value: element.value,
            title: element.value.toString(),
            radius: 60.0,
            titlePositionPercentageOffset: 1.4,
            titleStyle: TextStyle(
                color: HexColors.black,
                fontSize: 14.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w500)));
      }
    });
  }

  Future _getTitles() async {
    setState(() {
      for (var element in widget.items) {
        _titles.add(FittedBox(
            child: Row(children: [
          Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                  color: element.color,
                  borderRadius: BorderRadius.circular(6.0)),
              child: Center(
                child: Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                        color: HexColors.white,
                        borderRadius: BorderRadius.circular(3.0))),
              )),
          const SizedBox(width: 6.0),
          Text(element.name,
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 10.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.w500))
        ])));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          AspectRatio(
              aspectRatio: 1.25,
              child: PieChart(PieChartData(
                  startDegreeOffset: 180,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0.0,
                  centerSpaceRadius: 70.0,
                  sections: _sections,
                  centerSpaceColor: HexColors.white,
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  })))),
          const SizedBox(height: 20.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14.0,
                  runSpacing: 10.0,
                  children: _titles))
        ]);
  }
}
