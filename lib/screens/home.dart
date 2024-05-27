import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/fl_chart.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/calculatorHesab.dart';
import 'package:payment/screens/listTransaction.dart';
import 'package:intl/intl.dart';
import 'package:payment/widgets/deletedPersonDialogHome.dart';
import 'package:payment/widgets/sortedDialogHome.dart';
import 'package:payment/widgets/draverWidget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences _prefs;

  bool _SortedAccording = true;
  bool _SortedAs = false;

  void _saveSortedSettings(bool SortedAccording, bool SortedAs) {
    _prefs.setBool('SortedAccording', SortedAccording);
    _prefs.setBool('SortedAs', SortedAs);
    // ...
  }

  // تابع برای بارگیری تنظیمات
  void _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _SortedAccording = _prefs.getBool('SortedAccording') ?? true;
      _SortedAs = _prefs.getBool('SortedAs') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();

    final themeData = Theme.of(context);
    setState(() {
      name = datauserdata.name.toString();
    });

    return Scaffold(
        //endDrawer: MyDrawer(nameUser: boxdatauser.values.toList()[0].name,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return AddPerson();
            }));
          },
          child: Container(
            width: 175,
            height: 50,
            decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'افزودن طرف حساب',
                  style: themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 8,
                ),
                const Icon(
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
            physics: BouncingScrollPhysics(),
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
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              themeData.colorScheme.onTertiary),
                                      child: Icon(
                                        Icons.calendar_month_outlined,
                                        size: 25,
                                        color: themeData.colorScheme.onPrimary,
                                      ))
                                  // Image.asset(
                                  //   'assets/images/png/calender.png',
                                  //   scale: 7,
                                  // ),
                                ],
                              ),
                              ValueListenableBuilder(
                                  valueListenable: boxdatauser.listenable(),
                                  builder: (context, valuee, child) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 200
                                          ,child: Directionality(
                                            textDirection: ui.TextDirection.rtl,
                                            child: Text(

                                                  boxdatauser.values
                                                      .toList()[0]
                                                      .name,
                                              style: themeData
                                                  .textTheme.subtitle1!
                                                  .copyWith(
                                                      color: themeData.colorScheme
                                                          .onTertiary),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.account_circle_rounded,
                                          size: 35,
                                          color:
                                              themeData.colorScheme.onTertiary,
                                        )
                                        // Image.asset(
                                        //   'assets/images/png/user.png',
                                        //   scale: 7,
                                        // ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'بستانکاری',
                                                style: themeData
                                                    .textTheme.subtitle1!
                                                    .copyWith(fontSize: 12),
                                              ),
                                              Row(
                                                children: [
                                                  Text('تومان',
                                                      style: themeData
                                                          .textTheme.headline3),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    child: FittedBox(
                                                      child: Directionality(
                                                        textDirection:ui.TextDirection.rtl ,
                                                        child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          replaceFarsiNumber(
                                                              value.format(
                                                                  hesab.talab())),
                                                          style: themeData
                                                              .textTheme
                                                              .subtitle2!
                                                              .copyWith(
                                                                  height: 1,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: themeData
                                                  .colorScheme.primaryContainer,
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
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'بدهکاری',
                                                style: themeData
                                                    .textTheme.subtitle1!
                                                    .copyWith(fontSize: 12),
                                              ),
                                              Row(
                                                children: [
                                                  Text('تومان',
                                                      style: themeData
                                                          .textTheme.headline3),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    replaceFarsiNumber(
                                                        value.format(
                                                            hesab.bedehi())),
                                                    style: themeData
                                                        .textTheme.subtitle2!
                                                        .copyWith(
                                                            height: 1,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color:
                                                  themeData.colorScheme.error,
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
                                      width: 110,
                                      height: 110,
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
                            color: themeData.colorScheme.primary, width: 2)),
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
                              prefixIcon: Icon(
                                Icons.person_search,
                                size: 35,
                              )

                              // Image.asset(
                              //   'assets/images/png/search.png',
                              //   scale: 10,
                              // )
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ConstrainedBox(
                  //fit to bottom box list account
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 380,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          SelectedValues? selectedValues =
                                              await showDialog<SelectedValues>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SortedDialogHome(
                                                selectedAccordingValue:
                                                    _SortedAccording,
                                                selectedAsValue: _SortedAs,
                                              );
                                            },
                                          );

                                          if (selectedValues != null) {
                                            print(
                                                'Selected according value: ${selectedValues.selectedAccordingValue}');
                                            print(
                                                'Selected as value: ${selectedValues.selectedAsValue}');
                                            setState(() {
                                              _saveSortedSettings(
                                                  selectedValues
                                                      .selectedAccordingValue,
                                                  selectedValues
                                                      .selectedAsValue);
                                            });
                                            //_saveSortedSettings(selectedValues.selectedAccordingValue, selectedValues.selectedAsValue)
                                          } else {
                                            print('Dialog was dismissed.');
                                          }
                                        },
                                        child: Icon(Icons.more_vert_rounded)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                                Text('لیست طرف حساب ها',
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
                                      sortedAs: _SortedAs,
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 32,
                                        ),
                                        Image.asset(
                                          'assets/images/png/empty_list.png',
                                          scale: 2,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Directionality(
                                          textDirection: ui.TextDirection.rtl,
                                          child: Text(
                                            'طرف حسابی پیدا نشد.\n با گزینه "افزودن طرف حساب" ایجاد کنید.',
                                            textAlign: TextAlign.center,
                                            style: themeData
                                                .textTheme.subtitle1!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                          ),
                                        )
                                      ],
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
    required this.sortedAs,
  });

  final Box<Transactions> boxtrx;
  final Box<Accounts> boxacc;
  final ThemeData themeData;
  final CalculatorHesab hesab;
  final bool sortedAs;

  @override
  Widget build(BuildContext context) {
    final List<Accounts> datas = boxacc.values
        .where((element) => element.name.contains(_controller.text))
        .toList();

    int customCompare(String a, String b) {
      // اولویت رشته‌های فارسی
      if (a.contains(RegExp(r'[\u0600-\u06FF]')) &&
          !b.contains(RegExp(r'[\u0600-\u06FF]'))) {
        return -1;
      } else if (!a.contains(RegExp(r'[\u0600-\u06FF]')) &&
          b.contains(RegExp(r'[\u0600-\u06FF]'))) {
        return 1;
      }

      // اولویت رشته‌های لاتین
      if (a.contains(RegExp(r'[a-zA-Z]')) && !b.contains(RegExp(r'[a-zA-Z]'))) {
        return -1;
      } else if (!a.contains(RegExp(r'[a-zA-Z]')) &&
          b.contains(RegExp(r'[a-zA-Z]'))) {
        return 1;
      }

      // اولویت اعداد
      if (a.contains(RegExp(r'[0-9]')) && !b.contains(RegExp(r'[0-9]'))) {
        return -1;
      } else if (!a.contains(RegExp(r'[0-9]')) &&
          b.contains(RegExp(r'[0-9]'))) {
        return 1;
      }

      // در صورتی که هیچ یک از شرایط بالا برقرار نبود، از مقایسه معمولی استفاده می‌کنیم
      return a.compareTo(b);
    }

    datas.sort((a, b) => customCompare(a.name, b.name));

    return ListView.builder(
      reverse: sortedAs,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: datas.length,
      itemBuilder: (context, index) {
        final Accounts data = datas[index];
        int tempprice = hesab.fullhesabperson(data.id);

        // print(data.id.toString()+' '+data.name.toString());

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
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: InkWell(
        onLongPress: () async {
          bool x=await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeletedPersonDialogHome(
                name: widget.name, accitem: widget.accitem,
              );
            },
          );

          if(x){
            setState(() {

            });
          }
        },
        // {
        //   settingaccount(context, widget.themeData, widget.accitem);
        // },
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ListTransaction(
              id: widget.id,
            );
          })).then((value) => setState(() {
                hesab = CalculatorHesab(boxacc, boxtrx);
                FocusManager.instance.primaryFocus?.unfocus();
          }));
        },
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: widget.themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            ? themeData.colorScheme.primaryContainer
                            : themeData.colorScheme.error,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Text(widget.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: widget.themeData.textTheme.headline3!
                                      .copyWith(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Text(
                                  'تومان',
                                  style: widget.themeData.textTheme.headline3!.copyWith(
                                      color: Colors.black,
                                      height: 0.4,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 13),
                                ),
                                SizedBox(width: 8,),
                                Text(
                                    overflow: TextOverflow.ellipsis,
                                    replaceFarsiNumber(
                                        value.format(int.parse(widget.price))),
                                    style: widget.themeData.textTheme.headline3!
                                        .copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    )),

                              ],
                            ),


                        ],
                      ),
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
            color: themeData.colorScheme.primary,
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
              onTap: () {
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              },

            controller: controller,
            maxLength: 30,
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

sorteddialog(BuildContext context, ThemeData themeData) {
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
        child: Center(child: Text('مرتب سازی لیست حساب'))),
    //actionsAlignment: MainAxisAlignment.start,
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),
    actions: [
      TextButton(
          onPressed: () async {},
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

// تابع برای ذخیره تنظیمات
