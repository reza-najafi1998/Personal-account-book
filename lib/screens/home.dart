import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/fl_chart.dart';
import 'package:payment/calculatorHesab.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/screens/contacts-deactive.dart';
import 'package:payment/screens/listTransaction.dart';
import 'package:intl/intl.dart';
import 'package:payment/services/sortedList.dart';
import 'package:payment/widgets/coachmarkDesc.dart';
import 'package:payment/widgets/deletedPersonDialogHome.dart';
import 'package:payment/widgets/headerHomePage.dart';
import 'package:payment/widgets/sortedDialogHome.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'dart:ui' as ui;

import '../data/data.dart';
import '../widgets/headerHomePage.dart';

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

//get name
final datauserdata = boxdatauser.values.toList()[0];
String name = '';

CalculatorHesab hesab = CalculatorHesab(boxacc, boxtrx);

final value = NumberFormat("#,##0", "en_US");
var now = new DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
Gregorian g = Gregorian(now.year, now.month, now.day);
String jalaidate =
    '${now.toJalali().year}/${now.toJalali().month}/${now.toJalali().day}';

class _HomeState extends State<Home> {
  late SharedPreferences _prefs;

  bool _SortedAccording = true;
  bool _SortedAs = false;
  bool _Coach = true;

  //save sorting siting
  void _saveSortedSettings(bool SortedAccording, bool SortedAs) {
    _prefs.setBool('SortedAccording', SortedAccording);
    _prefs.setBool('SortedAs', SortedAs);
    // ...
  }

  // get setting
  Future _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _SortedAccording = _prefs.getBool('SortedAccording') ?? true;
      _SortedAs = _prefs.getBool('SortedAs') ?? false;
      _Coach = _prefs.getBool('CoachHome') ?? true;
      if(_Coach==true){
        inserttestdata();
      }
    });
  }

  //coach
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey headerkey = GlobalKey();
  GlobalKey listpersonkey = GlobalKey();
  GlobalKey sortedkey = GlobalKey();
  GlobalKey searchkey = GlobalKey();
  GlobalKey addpersonkey = GlobalKey();
  GlobalKey itempersonkey = GlobalKey();

  void _showTutorialCoachmark() {
    initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      pulseEnable: false,
      hideSkip: true,
    )..show(context: context);
  }

  void initTarget() {
    targets = [
      TargetFocus(
          identify: "header-key",
          keyTarget: headerkey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                  'به کمک نمودار بصورت کلی جمع میزان بستانکاری و بدهکاری شما نمایش داده می شود.',
                  onSkip: () {controller.skip();_prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                  },
                );
              },
            )
          ]),
      TargetFocus(
          identify: "listperson-key",
          keyTarget: listpersonkey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                  'لیستی از طرف حساب های شما به همراه جمع مبلغ حساب نمایش داده می شود، برای مشاهده گزارش تراکنش ها و افزودن تراکنش باید روی مخاطب لمس کنید.',
                  onSkip: () {controller.skip();_prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                  },

                );
              },
            )
          ]),
      TargetFocus(
          identify: "sorded-key",
          keyTarget: sortedkey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text: 'برای مرتب سازی لیست طرف حساب اینجا را لمس کنید.',
                  onSkip: () {controller.skip();_prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                  },

                );
              },
            )
          ]),
      TargetFocus(
          identify: "search-key",
          keyTarget: searchkey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                  'برای پیدا کردن طرف حساب در لیست کافیه اسم طرف حساب را اینجا وارد کنید',
                  onSkip: () {controller.skip();_prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                  },

                );
              },
            )
          ]),
      TargetFocus(
          identify: "itemperson-key",
          keyTarget: itempersonkey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text: 'برای حذف طرف حساب روی نام طرف لمس کنید و نگهدارید.',
                  onSkip: () {controller.skip();_prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                  },

                );
              },
            )
          ]),
      TargetFocus(
          identify: "addperson-key",
          keyTarget: addpersonkey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text: 'برای ایجاد طرف حساب جدید از این بخش استفاده کنید',
                  next: 'تمام',
                  onSkip: () {controller.skip();
                  _prefs.setBool('CoachHome', false);},
                  onNext: () {
                    controller.next();
                     _prefs.setBool('CoachHome', false);
                  },

                );
              },
            )
          ]),

    ];
  }
//

  Future inserttestdata()async{
    if(_Coach&&boxacc.values.length==0){

      Accounts test=Accounts();
      test.id=0;
      test.name='طرف حساب آموزشی';
      test.phone='0912345679';
      final Box<Accounts> boxacc = Hive.box('Accounts');
      await boxacc.add(test);

      Transactions trxtest=Transactions();
      trxtest.id=0;
      trxtest.status=true;
      trxtest.time='21:25:54';
      trxtest.price=1256000;
      trxtest.date='1403/03/20';
      trxtest.description='جهت آموزش برنامه';
      final Box<Transactions> boxtrx = Hive.box('Transactions');

      await boxtrx.add(trxtest);

      Transactions trxtest2=Transactions();

      trxtest2.id=0;
      trxtest2.status=false;
      trxtest2.time='21:28:54';
      trxtest2.price=356000;
      trxtest2.date='1403/03/20';
      trxtest2.description='جهت آموزش برنامه';
      await boxtrx.add(trxtest2);

    }
  }
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 1),
          () async{
        if(_Coach){
          _showTutorialCoachmark();
        }
      },
    );

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          key: addpersonkey,
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return AddPerson(name: '', phone: '');
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
                const SizedBox(
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                  width: MediaQuery.of(context).size.width,
                  // width: ,
                ),
                HeaderHomePage(
                  headerkey: headerkey,
                ),
                Padding(
                  key: searchkey,
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
                              )),
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
                      key: listpersonkey,
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
                                        key: sortedkey,
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
                                      sortedAs: _SortedAs, itemkey: itempersonkey,
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
    required this.sortedAs, required this.itemkey,
  });

  final Box<Transactions> boxtrx;
  final Box<Accounts> boxacc;
  final ThemeData themeData;
  final CalculatorHesab hesab;
  final bool sortedAs;
  final GlobalKey itemkey;

  @override
  Widget build(BuildContext context) {
    final List<Accounts> datas = boxacc.values
        .where((element) =>
            element.name.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

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
          itemkey: itemkey,
          themeData: themeData,
          id: data.id,
          name: data.name,
          price: tempprice.toString(),
          state: tempprice >= 0 ? true : false,
          date: hesab.lastdatetrx(data.id),
          accitem: data, index: index,
        );
      },
    );
  }
}

class _ItemHesabList extends StatefulWidget {
  final int id;
  final int index;
  final String name;
  final String price;
  final bool state;
  final String date;
  final ThemeData themeData;
  final Accounts accitem;
  final GlobalKey itemkey;

  const _ItemHesabList({
    required this.themeData,
    required this.name,
    required this.price,
    required this.state,
    required this.id,
    required this.date,
    required this.accitem, required this.itemkey, required this.index,
  });

  @override
  State<_ItemHesabList> createState() => _ItemHesabListState();
}

class _ItemHesabListState extends State<_ItemHesabList> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      key:widget.index==0?widget.itemkey:null,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: InkWell(
        onLongPress: () async {
          bool x = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeletedPersonDialogHome(
                name: widget.name,
                accitem: widget.accitem,
              );
            },
          );

          if (x) {
            setState(() {
              x=false;
            });
          }
        },
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
          height: 65,
          decoration: BoxDecoration(
            color: widget.themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Flex(
            direction: Axis.horizontal,
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
              Expanded(
                flex: 5,
                child: Flex(
                  direction: Axis.horizontal,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                style: widget.themeData.textTheme.headline3!
                                    .copyWith(
                                        color: Colors.black,
                                        height: 0.4,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 13),
                              ),
                              SizedBox(
                                width: 8,
                              ),
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
                ),
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
