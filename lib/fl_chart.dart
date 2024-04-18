import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/setting.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart(
      {super.key,
      required this.talab,
      required this.bedehi,
      required this.themeData});

  final double talab;
  final double bedehi;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    final value = NumberFormat("#,##0", "en_US");

    return Stack(
      children: [
        Stack(children: [
          Positioned.fill(
            child: PieChart(
                swapAnimationDuration: const Duration(milliseconds: 1000),
                swapAnimationCurve: Curves.linear,
                PieChartData(sections: [
                  //item 1
                  PieChartSectionData(
                      value: bedehi+talab==0?1:bedehi * (-1),
                      color: const Color(0xfff82442),
                      radius: 25,
                      showTitle: false),

                  //item2
                  PieChartSectionData(
                    value: bedehi+talab==0?1:talab,
                    color: const Color(0xff00f53f),
                    radius: 25,
                    showTitle: false,
                  )
                ])),
          ),
          Center(child: 
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: talab>bedehi?const Color(0xff00f53f):const Color(0xfff82442),
              ),
            ),)
          // Center(
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           CupertinoPageRoute(
          //             builder: (context) => Settingpage(),
          //           ));
          //       print('object');
          //     },
          //     child: Container(
          //       width: 50,
          //       height: 80,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(
          //             Icons.settings,
          //             size: 38,
          //           ),
          //           Text(
          //             'تنظیمات',
          //             style: themeData.textTheme.headline3!.copyWith(
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.w400,
          //                 fontSize: 13),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ]),

      ],
    );
  }
}
