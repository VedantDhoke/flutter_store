import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueChart extends StatefulWidget {
  @override
  _RevenueChartState createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  bool isShowingMainData = true;

  List<FlSpot> sampleRevenueData1 = [
    FlSpot(0, 200),
    FlSpot(1, 400),
    FlSpot(2, 350),
    FlSpot(3, 500),
    FlSpot(4, 600),
  ];

  List<FlSpot> sampleRevenueData2 = [
    FlSpot(0, 100),
    FlSpot(1, 200),
    FlSpot(2, 250),
    FlSpot(3, 300),
    FlSpot(4, 450),
  ];

  List<FlSpot> get chartData =>
      isShowingMainData ? sampleRevenueData1 : sampleRevenueData2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('Revenue Data Chart', style: TextStyle(fontSize: 20)),
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
                  color: Colors.green,
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
