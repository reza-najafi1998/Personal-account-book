import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:payment/calculatorHesab.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class SettlementTrx extends StatefulWidget {
  final int id;

  const SettlementTrx({Key? key, required this.id}) : super(key: key);

  @override
  _SettlementTrxState createState() => _SettlementTrxState();
}


class _SettlementTrxState extends State<SettlementTrx> {
  @override
  Widget build(BuildContext context) {
    String personName = hesab.getname(widget.id).toString();
    final ThemeData themeData = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      titlePadding: EdgeInsets.all(0),
      title: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: themeData.colorScheme.primary,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Center(child: Text('تسویه حساب')),
      ),
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text('شما در حال تسویه حساب «' + personName + '» هستید.',
              textAlign: TextAlign.center,)),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: themeData.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: hesab.fullhesabperson(widget.id) >= 0
                                ? themeData.colorScheme.error
                                : themeData.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: hesab.fullhesabperson(widget.id) >= 0
                              ? Image.asset('assets/images/png/down.png')
                              : Image.asset('assets/images/png/up.png'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              replaceFarsiNumber(value
                                  .format(hesab.fullhesabperson(widget.id)*-1)),
                              style: themeData.textTheme.headline3!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'تومان',
                            style: themeData.textTheme.headline3!.copyWith(
                                color: Colors.black,
                                height: 0.4,
                                fontWeight: FontWeight.w400,
                                fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Text('  مبلغ تسویه :',
                        style: themeData.textTheme.headline3!
                            .copyWith(
                                color: Colors.black, fontSize: 13)),
                  ),
                 // SizedBox(width: 8,)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          hesab.fullhesabperson(widget.id) >= 0?
          Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text('شما به «$personName» بستانکار هستید. ')):Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text('شما به «$personName» بدهکار هستید. ')),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  print(hesab.fullhesabperson(widget.id));

                  final transactions = Transactions();
                  var now = new DateTime.now();
                  Gregorian g = Gregorian(now.year, now.month, now.day);
                  transactions.id=widget.id;
                  transactions.status = hesab.fullhesabperson(widget.id) >= 0?false:true;
                  transactions.price = hesab.fullhesabperson(widget.id)>0?hesab.fullhesabperson(widget.id):hesab.fullhesabperson(widget.id)*-1;
                  transactions.description =
                      'بابت تسویه حساب «با تسویه حساب سیستم»';

                  final Box<Transactions> box = Hive.box('transactions');

                  transactions.date = '${g.toJalali().year}/${g.toJalali().month}/${g.toJalali().day}';
                  transactions.time = '${now.hour}:${now.minute}:${now.second}';
                  await box.add(transactions);

                  // print(transactions.id);
                  // print(transactions.description);
                  // print(transactions.price);
                  // print(transactions.status);
                  // print(transactions.date);
                  // print(transactions.time);

                  Navigator.pop(context,true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'تسویه حساب کن',
                        style: themeData.textTheme.headline3!
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
