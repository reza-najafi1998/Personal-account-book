import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/fl_chart.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/calculatorHesab.dart';
import 'package:payment/screens/listTransaction.dart';
import 'package:intl/intl.dart';
import 'package:payment/widgets/draverWidget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

// import 'package:shamsi_date/shamsi_date.dart';
import 'dart:ui' as ui;

import '../data/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final TextEditingController _controller = TextEditingController();
final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

final boxtrx = Hive.box<Transactions>('Transactions');
final boxacc = Hive.box<Accounts>('Accounts');
final boxdatauser = Hive.box<DataUser>('User');
final datauserdata = boxdatauser.values.toList()[0];
CalculatorHesab hesab = CalculatorHesab(boxacc, boxtrx);
String name = '';
final value = NumberFormat("#,##0", "en_US");
var now = new DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
Gregorian g = Gregorian(now.year, now.month, now.day);
String jalaidate = now.toJalali().year.toString() +
    '/' +
    now.toJalali().month.toString() +
    '/' +
    now.toJalali().day.toString();

class _HomeState extends State<Home> {
  // @override
  // void initState() {
  //   super.initState();
  //   name = datauserdata.name.toString();
  // }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    setState(() {
      // print('00000000000000000000000000000000000000000000000000000000000000000');
      // print(hesab.talab().toString());
      // print(hesab.bedehi().toString());
      name = datauserdata.name.toString();
    });

    return Scaffold(
        endDrawer: MyDrawer(nameUser: boxdatauser.values.toList()[0].name,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return AddPerson();
            }));
          },
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'افزودن حساب',
                  style:
                  themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
                ),                SizedBox(width: 8,)
                ,const Icon(
                  CupertinoIcons.plus_circle,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                  width: MediaQuery.of(context).size.width,
                  // width: ,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        weekdayjalali(),
                                        style: themeData.textTheme.subtitle1!
                                            .copyWith(fontSize: 12),
                                      ),
                                      Text(
                                        replaceFarsiNumber(jalaidate),
                                        style: themeData.textTheme.headline3,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Image.asset(
                                    'assets/images/png/calender.png',
                                    scale: 7,
                                  ),
                                ],
                              ),
                              // Container(
                              //   // decoration: BoxDecoration(
                              //   //   color: themeData.colorScheme.secondary.withOpacity(0.2),
                              //   //   borderRadius: BorderRadius.circular(8),
                              //   //   boxShadow: [
                              //   //     BoxShadow(
                              //   //       color: Colors.black.withOpacity(0.05),
                              //   //       blurRadius: 10
                              //   //     )
                              //   //   ]
                              //   // ),
                              //   child: Row(children: [
                              //     Icon(Icons.menu_rounded,size: 45,)
                              //   ],),
                              // )
                              ValueListenableBuilder(
                                  valueListenable: boxdatauser.listenable(),
                                  builder: (context, valuee, child) {
                                    return Row(
                                      children: [
                                        Directionality(
                                          textDirection: ui.TextDirection.rtl,
                                          child: Text(
                                            boxdatauser.values.toList()[0].name +
                                                ' جان ، خوش آمدید',
                                            style: themeData.textTheme.subtitle1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          child: Image.asset(
                                            'assets/images/png/user.png',
                                            scale: 7,
                                          ),
                                          onTap: () {
                                            Scaffold.of(context).openEndDrawer();
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ValueListenableBuilder(
                            valueListenable: boxtrx.listenable(),
                            builder: (context, valuee, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text('تومان',
                                              style:
                                                  themeData.textTheme.headline3),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            replaceFarsiNumber(
                                                value.format(hesab.talab())),
                                            style: themeData.textTheme.subtitle2!
                                                .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xff00f53f),
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
                                        children: [
                                          Text('تومان',
                                              style:
                                                  themeData.textTheme.headline3),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            replaceFarsiNumber(
                                                value.format(hesab.bedehi())),
                                            style: themeData.textTheme.subtitle2!
                                                .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xfff82442),
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
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: 130,
                                      height: 130,
                                      child: MyPieChart(
                                        talab: hesab.talab().toDouble(),
                                        bedehi: hesab.bedehi().toDouble(),
                                        themeData: themeData,
                                      ))

                                  // Image.asset(
                                  //   'assets/images/png/chart.png',
                                  //   scale: 3,
                                  // ),
                                  //Image.asset('assets/images/png/arrow.png')
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(255, 175, 5, 167),
                            width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextField(
                          onTap: () {
                            _controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: _controller.text.length));
                          },
                          onChanged: (value) {
                            setState(() {
                              searchKeywordNotifier.value = _controller.text;
                            });
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                              hintTextDirection: ui.TextDirection.rtl,
                              border: InputBorder.none,
                              hintText: 'سریع پیداش کن...',
                              prefixIcon: Image.asset(
                                'assets/images/png/search.png',
                                scale: 10,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.account_balance_outlined),
                                Text('لیست حساب ها',
                                    style: themeData.textTheme.subtitle2!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                              ],
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: boxtrx.listenable(),
                            builder: (context, value, child) {
                              return boxacc.values.isNotEmpty
                                  ? _ListBuilderAccounts(

                                      boxtrx: boxtrx,
                                      boxacc: boxacc,
                                      themeData: themeData,
                                      hesab: hesab,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: Image.asset(
                                        'assets/images/png/empty_list.png',
                                        scale: 2,
                                      ),
                                    );
                            },
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _ListBuilderAccounts extends StatelessWidget {
  const _ListBuilderAccounts({
    super.key,
    required this.themeData,
    required this.boxtrx,
    required this.boxacc,
    required this.hesab,
  });

  final Box<Transactions> boxtrx;
  final Box<Accounts> boxacc;
  final ThemeData themeData;
  final CalculatorHesab hesab;

  @override
  Widget build(BuildContext context) {
    final List<Accounts> datas = boxacc.values
        .where((element) => element.name.contains(_controller.text))
        .toList();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: datas.length,
      itemBuilder: (context, index) {
        final Accounts data = datas[index];
        int tempprice = hesab.fullhesabperson(data.id);

        return _ItemHesabList(
          themeData: themeData,
          id: data.id,
          name: data.name,
          price: tempprice.toString(),
          state: tempprice >= 0 ? true : false,
          date: hesab.lastdatetrx(data.id),
          accitem: data,
        );
      },
    );
  }
}

class _ItemHesabList extends StatefulWidget {
  final int id;
  final String name;
  final String price;
  final bool state;
  final String date;
  final ThemeData themeData;
  final Accounts accitem;

  const _ItemHesabList({
    required this.themeData,
    required this.name,
    required this.price,
    required this.state,
    required this.id,
    required this.date,
    required this.accitem,
  });

  @override
  State<_ItemHesabList> createState() => _ItemHesabListState();
}

class _ItemHesabListState extends State<_ItemHesabList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: InkWell(
        onLongPress: () {
          settingaccount(context, widget.themeData, widget.accitem);
        },
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ListTransaction(
              id: widget.id,
            );
          })).then((value) => setState(() {
                hesab = CalculatorHesab(boxacc, boxtrx);
              }));
        },
        child: Container(
          width: 360,
          height: 70,
          decoration: BoxDecoration(
            color: widget.themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: widget.state
                            ? const Color.fromARGB(255, 4, 246, 28)
                            : const Color.fromARGB(255, 246, 28, 4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: widget.state
                          ? Image.asset(
                              'assets/images/png/up.png',
                              scale: 3,
                            )
                          : Image.asset(
                              'assets/images/png/down.png',
                              scale: 3,
                            ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          replaceFarsiNumber(
                              value.format(int.parse(widget.price))),
                          style: widget.themeData.textTheme.headline3!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        'تومان',
                        style: widget.themeData.textTheme.headline3!.copyWith(
                            color: Colors.black,
                            height: 0.4,
                            fontWeight: FontWeight.w100,
                            fontSize: 13),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(widget.name,
                      style: widget.themeData.textTheme.headline3!.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 4,
                  ),
                  Image.asset(
                    'assets/images/png/user.png',
                    width: 45,
                  ),
                  const SizedBox(
                    width: 6,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }

  return input;
}

String weekdayjalali() {
  switch (now.toJalali().weekDay) {
    case 1:
      return 'شنبه';
    case 2:
      return 'یک شنبه';
    case 3:
      return 'دوشنبه';
    case 4:
      return 'سه شنبه';
    case 5:
      return 'چهار شنبه';
    case 6:
      return 'پنج شنبه';
    case 7:
      return 'جمعه';
    default:
      return '';
  }
}

settingaccount(BuildContext context, ThemeData themeData, Accounts accitem) {
  TextEditingController controller = TextEditingController();
  controller.text = accitem.name;
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    titlePadding: EdgeInsets.all(0),
    title: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Center(child: Text('فرم ویرایش حساب'))),
    //actionsAlignment: MainAxisAlignment.start,
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),
    actions: [
      SizedBox(
        height: 16,
      ),
      Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: TextField(
            controller: controller,
            maxLength: 8,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                counterText: "",
                label: Text('ویرایش نام'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ),
      TextButton(
          onPressed: () async {
            if (controller.text.isNotEmpty) {
              if (accitem.name != controller.text) {
                accitem.name = controller.text;
                await accitem.save();
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }

              //SystemNavigator.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Text('مقدار نام خالی است.')),
              ));
            }
          },
          child: Container(
              //height: 50,
              //width: 150,
              decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ثبت',
                  style: themeData.textTheme.headline3!
                      .copyWith(fontSize: 20, color: Colors.white),
                ),
              ))))
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
