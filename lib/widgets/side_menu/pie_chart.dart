// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class PieChartSample1 extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => PieChartSample1State();
// }

// class PieChartSample1State extends State<PieChartSample1> {
//   int? touchedIndex;

//   List<PieChartSectionData> showingSections() {
//     return List.generate(4, (index) {
//       final isTouched = index == touchedIndex;
//       final fontSize = isTouched ? 18.0 : 16.0;
//       final radius = isTouched ? 80.0 : 70.0;
//       const shadows = [BoxShadow(color: Colors.black45, blurRadius: 4)];
//       switch (index) {
//         case 0:
//           return PieChartSectionData(
//             color: const Color(0xff0293ee),
//             value: 40,
//             title: 'One',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: isTouched ? shadows : null,
//             ),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: const Color(0xfff8b250),
//             value: 30,
//             title: 'Two',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: isTouched ? shadows : null,
//             ),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: const Color(0xff845bef),
//             value: 15,
//             title: 'Three',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: isTouched ? shadows : null,
//             ),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: const Color(0xff13d38e),
//             value: 15,
//             title: 'Four',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: isTouched ? shadows : null,
//             ),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Card(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 28),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 _Indicator(
//                     color: const Color(0xff0293ee),
//                     text: 'One',
//                     isSelected: touchedIndex == 0),
//                 _Indicator(
//                     color: const Color(0xfff8b250),
//                     text: 'Two',
//                     isSelected: touchedIndex == 1),
//                 _Indicator(
//                     color: const Color(0xff845bef),
//                     text: 'Three',
//                     isSelected: touchedIndex == 2),
//                 _Indicator(
//                     color: const Color(0xff13d38e),
//                     text: 'Four',
//                     isSelected: touchedIndex == 3),
//               ],
//             ),
//             const SizedBox(height: 18),
//             Expanded(
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: PieChart(
//                   PieChartData(
//                     pieTouchData: PieTouchData(
//                       touchCallback: (event, pieTouchResponse) {
//                         setState(() {
//                           touchedIndex =
//                               pieTouchResponse?.touchedSection?.index;
//                         });
//                       },
//                     ),
//                     startDegreeOffset: 180,
//                     borderData: FlBorderData(show: false),
//                     sectionsSpace: 12,
//                     centerSpaceRadius: 0,
//                     sections: showingSections(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Indicator extends StatelessWidget {
//   final Color color;
//   final String text;
//   final bool isSelected;

//   _Indicator(
//       {required this.color, required this.text, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           color: color,
//         ),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: isSelected ? 18 : 16,
//             color: isSelected ? Colors.black : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
