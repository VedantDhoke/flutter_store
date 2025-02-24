// import 'dart:async';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class BarChartSample1 extends StatefulWidget {
//   final List<Color> availableColors = [
//     Colors.purpleAccent,
//     Colors.yellow,
//     Colors.lightBlue,
//     Colors.orange,
//     Colors.pink,
//     Colors.redAccent,
//   ];

//   @override
//   State<StatefulWidget> createState() => BarChartSample1State();
// }

// class BarChartSample1State extends State<BarChartSample1> {
//   final Color barBackgroundColor = const Color(0xff72d8bf);
//   final Duration animDuration = const Duration(milliseconds: 250);

//   int touchedIndex = -1;
//   bool isPlaying = false;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//         color: const Color(0xff81e5cd),
//         child: Stack(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   Text(
//                     'Mingguan',
//                     style: TextStyle(
//                         color: const Color(0xff0f4a3c),
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     'Grafik konsumsi kalori',
//                     style: TextStyle(
//                         color: const Color(0xff379982),
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 38,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: BarChart(
//                         isPlaying ? randomData() : mainBarData(),
//                         swapAnimationDuration: animDuration,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                   icon: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: const Color(0xff0f4a3c),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isPlaying = !isPlaying;
//                       if (isPlaying) {
//                         refreshState();
//                       }
//                     });
//                   },
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   BarChartGroupData makeGroupData(
//     int x,
//     double y, {
//     bool isTouched = false,
//     Color barColor = Colors.white,
//     double width = 22,
//     List<int> showTooltips = const [],
//   }) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           fromY: 0,
//           toY: isTouched ? y + 1 : y,
//           color: isTouched ? Colors.yellow : barColor,
//           width: width,
//           backDrawRodData: BackgroundBarChartRodData(
//             show: true,
//             fromY: 0,
//             toY: 20,
//             color: barBackgroundColor,
//           ),
//         ),
//       ],
//       showingTooltipIndicators: showTooltips,
//     );
//   }

//   List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
//         switch (i) {
//           case 0:
//             return makeGroupData(0, 5, isTouched: i == touchedIndex);
//           case 1:
//             return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
//           case 2:
//             return makeGroupData(2, 5, isTouched: i == touchedIndex);
//           case 3:
//             return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
//           case 4:
//             return makeGroupData(4, 9, isTouched: i == touchedIndex);
//           case 5:
//             return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
//           case 6:
//             return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
//           default:
//             return makeGroupData(0, 0);
//         }
//       });

//   BarChartData mainBarData() {
//     return BarChartData(
//       barTouchData: BarTouchData(
//         touchTooltipData: BarTouchTooltipData(
//           getTooltipColor: (value) => Colors.blueGrey,
//           tooltipPadding: const EdgeInsets.all(8.0),
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             String weekDay;
//             switch (group.x.toInt()) {
//               case 0:
//                 weekDay = 'Monday';
//                 break;
//               case 1:
//                 weekDay = 'Tuesday';
//                 break;
//               case 2:
//                 weekDay = 'Wednesday';
//                 break;
//               case 3:
//                 weekDay = 'Thursday';
//                 break;
//               case 4:
//                 weekDay = 'Friday';
//                 break;
//               case 5:
//                 weekDay = 'Saturday';
//                 break;
//               case 6:
//                 weekDay = 'Sunday';
//                 break;
//               default:
//                 weekDay = 'Unknown';
//             }
//             return BarTooltipItem(
//               '$weekDay\n${rod.toY.toStringAsFixed(1)}',
//               TextStyle(color: Colors.yellow),
//             );
//           },
//         ),
//         touchCallback: (BarTouchResponse barTouchResponse) {
//           setState(() {
//             if (barTouchResponse.spot != null) {
//               if (barTouchResponse.touchInput != null) {
//                 touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
//               } else {
//                 touchedIndex = -1;
//               }
//             }
//           });
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: true),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(show: false),
//       barGroups: showingGroups(),
//     );
//   }

//   BarChartData randomData() {
//     return BarChartData(
//       barTouchData: BarTouchData(
//         enabled: false,
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: true),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(show: false),
//       barGroups: List.generate(7, (i) {
//         return makeGroupData(
//           i,
//           Random().nextInt(15).toDouble() + 6,
//           barColor: widget
//               .availableColors[Random().nextInt(widget.availableColors.length)],
//         );
//       }),
//     );
//   }

//   Future<void> refreshState() async {
//     setState(() {});
//     await Future.delayed(animDuration + const Duration(milliseconds: 50));
//     if (isPlaying) {
//       refreshState();
//     }
//   }
// }
