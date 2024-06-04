import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/services/saveFile.dart';
import 'package:payment/widgets/deletedAllDialogSetting.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Settingpage extends StatefulWidget {
  @override
  State<Settingpage> createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  Future<int> _createBackup() async {
    //return => 0 error
    //return => 1 ok
    //return => 2 Permission
    var statusstorage = await Permission.storage.status;
    // اگر مجوز داده نشده، درخواست مجوز کنید
    if (!statusstorage.isGranted) {
      await Permission.storage.request();
      return 2;
    } else {
      try {
        //گرفتن اطلاعات دیتابیس
        final boxtrx = Hive.box<Transactions>('Transactions');
        final boxacc = await Hive.box<Accounts>('Accounts');
        final boxdatauser = Hive.box<DataUser>('User');

        List<Map<String, dynamic>> accountslist = [];
        for (var data in boxacc.values) {
          Map<String, dynamic> newaccmap = {
            'id': data.id,
            'name': data.name,
            'phone': data.phone,
          };
          accountslist.add(newaccmap);
        }

        List<Map<String, dynamic>> transactionslist = [];
        for (var data in boxtrx.values) {
          Map<String, dynamic> newtrxmap = {
            'id': data.id,
            'description': data.description,
            'price': data.price,
            'date': data.date,
            'time': data.time,
            'status': data.status
          };
          transactionslist.add(newtrxmap);
        }

        Map<String, dynamic> user = {
          'name': boxdatauser.values.toList()[0].name
        };

        // تبدیل به جیسون
        Map<String, dynamic> jsonData = {
          'transactions': transactionslist,
          'accounts': accountslist,
          'user': user,
        };

        String jsonString = jsonEncode(jsonData);

        //get data andtime to set file name
        var now = new DateTime.now();
        Gregorian g = Gregorian(now.year, now.month, now.day);

        String temptime = '${now.hour}-${now.minute}-${now.second}';

        String tempdate =
            '${g.toJalali().year}-${g.toJalali().month}-${g.toJalali().day}';
        String filename = 'Daftar Hesab $tempdate - $temptime';

        saveFile(filename, jsonString);
        return 1;
      } catch (e) {
        print('error : $e');
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            GridView.count(crossAxisSpacing: 8, crossAxisCount: 3, children: [
          _ItemsSetting(
            themeData: themeData,
            title: 'تغییر نام',
            iconurl: 'assets/images/svgs/edit_account.svg',
            onTop: () {
              dialogChangeName(context, themeData);
              print('object');
            },
          ),
          _ItemsSetting(
            themeData: themeData,
            title: 'دریافت نسخه پشتیبانی',
            iconurl: 'assets/images/svgs/backup.svg',
            onTop: () async {
              showAlertDialog(context, 'لطفا صبر کنید...');
              int resulte = await _createBackup();
              if (resulte == 0) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('خطا رخ داد است.'))),
                );
              } else if (resulte == 1) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              'پشتیبانی با موفقیت در دانلود ها ذخیره شده است.'))),
                );
              } else if (resulte == 2) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              'تایید مجوز برای ذخیره فایل پشتیبانی الزامی است.'))),
                );
              }
            },
          ),
          _ItemsSetting(
            themeData: themeData,
            title: 'درباره ما',
            iconurl: 'assets/images/svgs/about.svg',
            onTop: () {
              aboutalert(context, themeData);
            },
          ),
          _ItemsSetting(
            themeData: themeData,
            title: 'حذف همه اطلاعات',
            iconurl: 'assets/images/svgs/deleted_all.svg',
            onTop: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeletedAllDialogSetting();
                },
              );
            },
          ),
          _ItemsSetting(
            themeData: themeData,
            title: 'امتیاز بده',
            iconurl: 'assets/images/svgs/rank.svg',
            onTop: () async {
              const packageName = 'ir.rezadev.payment';  // این را با شناسه بسته برنامه خود جایگزین کنید
              const bazaarPackage = 'com.farsitel.bazaar';

              final intent = AndroidIntent(
                action: 'android.intent.action.VIEW',
                data: 'bazaar://details?id=$packageName',
                package: bazaarPackage,
                flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
              );

              try {
                await intent.launch();
              } catch (e) {
                print('Could not launch Bazaar: $e');
              }
            },
          ),
        ]),
      )),
    );
  }
}

showAlertDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 150,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(textDirection: TextDirection.rtl, child: Text(text)),
          SizedBox(
            width: 8,
          ),
          CircularProgressIndicator(
            value: null,
            strokeWidth: 7.0,
          ),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

dialogChangeName(BuildContext context, ThemeData themeData) {
  TextEditingController controller = TextEditingController();

  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    titlePadding: EdgeInsets.all(0),
    title: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: const Center(child: Text('فرم تغییر نام'))),
    //actionsAlignment: MainAxisAlignment.start,
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),
    actions: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: TextField(
            controller: controller,
            maxLength: 20,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                counterText: "",
                label: const Text('نام جدید را وارد کنید'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ),
      TextButton(
          onPressed: () async {
            if (controller.text.isNotEmpty) {
              await boxdatauser.clear();
              final datau = DataUser();
              datau.name = controller.text;
              await boxdatauser.add(datau);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text('نام شما با موفقیت تغییر کرد.')),
              ));
              //SystemNavigator.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Directionality(
                    textDirection: TextDirection.rtl,
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
    content: SizedBox(
      //width: 150,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: themeData.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(boxdatauser.values.toList()[0].name),
                  const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text('نام سابق : ')),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _ItemsSetting extends StatelessWidget {
  final ThemeData themeData;
  final String title;
  final String iconurl;
  final Function() onTop;

  const _ItemsSetting(
      {super.key,
      required this.themeData,
      required this.title,
      required this.onTop,
      required this.iconurl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTop(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: Container(
          width: 130,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconurl,
                width: 40,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.headline3!.copyWith(
                      color: themeData.colorScheme.onBackground,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

aboutalert(BuildContext context, ThemeData themeData) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

// ···
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'reza.najafi1871@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'دفتر حساب 1.0.1',
    }),
  );

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
        child: Center(child: Text('درباره ما'))),
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),
    actions: [
      Center(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'امید وارم از این اپلیکیشن لذت ببرید\nسعی می کنم مرتب آپدیت بزارم و بهترش کنم',
          textAlign: TextAlign.center,
          style: themeData.textTheme.subtitle1,
        ),
      )),
      SizedBox(
        height: 16,
      ),
      TextButton(
          onPressed: () async {
            launchUrl(emailLaunchUri);
          },
          child: Container(
              //height: 50,
              //width: 150,
              decoration: BoxDecoration(
                  color: themeData.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' تماس با ما',
                  style: themeData.textTheme.headline3!
                      .copyWith(fontSize: 20, color: Colors.white),
                ),
              )))),
      TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Container(
              //height: 50,
              //width: 150,
              decoration: BoxDecoration(
                  color: themeData.colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' ! کافیه',
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
