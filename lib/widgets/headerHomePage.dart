import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment/screens/home.dart';

import '../fl_chart.dart';

class HeaderHomePage extends StatelessWidget {
  final GlobalKey headerkey;
  const HeaderHomePage({super.key, required this.headerkey});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        key: headerkey,
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          //color: Colors.white,
          color: Color(0xFF003B69),
          borderRadius: BorderRadius.circular(15),
          boxShadow:[BoxShadow(
            color: Color(0xFF003B69).withOpacity(0.6),
            blurRadius: 5,
          )]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              weekdayjalali(),
                              style: themeData.textTheme.subtitle1!
                                  .copyWith(fontSize: 12, color: Colors.white),
                            ),
                            Text(
                              replaceFarsiNumber(jalaidate),
                              style: themeData.textTheme.headline3!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 25,
                              color: Color(0xFF003B69),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ValueListenableBuilder(
                        valueListenable: boxdatauser.listenable(),
                        builder: (context, valuee, child) {
                          return Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    'سلام ' +
                                        boxdatauser.values.toList()[0].name,
                                    style: themeData.textTheme.subtitle1!
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.account_circle_rounded,
                                size: 35,
                                color: Colors.white,
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ValueListenableBuilder(
                valueListenable: boxtrx.listenable(),
                builder: (context, valuee, child) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'بستانکاری',
                                            style: themeData.textTheme.subtitle1!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text('تومان',
                                                  style: themeData
                                                      .textTheme.headline3!
                                                      .copyWith(color: Colors.white)),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              SizedBox(
                                                width:(hesab.talab().toString().length*11) ,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
                                                    child: Text(
                                                      replaceFarsiNumber(value
                                                          .format(hesab.talab())),
                                                      style: themeData
                                                          .textTheme.subtitle2!
                                                          .copyWith(
                                                              height: 1,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color:
                                              themeData.colorScheme.primaryContainer,
                                        ),
                                        child: Image.asset(
                                          'assets/images/png/up.png',
                                          scale: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'بدهکاری',
                                            style: themeData.textTheme.subtitle1!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text('تومان',
                                                  style: themeData
                                                      .textTheme.headline3!
                                                      .copyWith(color: Colors.white)),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              SizedBox(
                                                width:(hesab.bedehi().toString().length*10) ,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    replaceFarsiNumber(
                                                        value.format(hesab.bedehi())),
                                                    style: themeData
                                                        .textTheme.subtitle2!
                                                        .copyWith(
                                                            height: 1,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: themeData.colorScheme.error,
                                        ),
                                        child: Image.asset(
                                          'assets/images/png/down.png',
                                          scale: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                            width: 110,
                            height: 110,
                            child: MyPieChart(
                              talab: hesab.talab().toDouble(),
                              bedehi: hesab.bedehi().toDouble(),
                              themeData: themeData,
                            )),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
