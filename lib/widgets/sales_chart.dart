import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesChart extends StatefulWidget {
  @override
  _SalesChartState createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  bool isShowingMainData = true;

  List<FlSpot> sampleData1 = [
    FlSpot(0, 1),
    FlSpot(1, 2),
    FlSpot(2, 1.5),
    FlSpot(3, 2.5),
    FlSpot(4, 3),
  ];

  List<FlSpot> sampleData2 = [
    FlSpot(0, 0.5),
    FlSpot(1, 1.5),
    FlSpot(2, 1),
    FlSpot(3, 3),
    FlSpot(4, 4),
  ];

  List<FlSpot> get chartData => isShowingMainData ? sampleData1 : sampleData2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('Sales Data Chart', style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Container(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: chartData,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isShowingMainData = !isShowingMainData;
            });
          },
          child: Text('Toggle Data'),
        ),
      ],
    );
  }
}
