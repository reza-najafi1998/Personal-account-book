import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/removeAccounts.dart';
import 'package:payment/services/saveFile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
// import 'package:shamsi_date/shamsi_date.dart';

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

        String temptime = now.hour.toString() +
            '-' +
            now.minute.toString() +
            '-' +
            now.second.toString();

        String tempdate = g.toJalali().year.toString() +
            '-' +
            g.toJalali().month.toString() +
            '-' +
            g.toJalali().day.toString();
        String filename = tempdate + '-' + temptime;

        List<int> bytes = jsonString.codeUnits;
        saveFile(filename, bytes);

        // final file =
        //     File(selectedDirectory + '/' + filename + '.txt');
        // await file.writeAsString(jsonString,
        //     mode: FileMode.write, encoding: utf8);

        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Directionality(
        //       textDirection: TextDirection.rtl,
        //       child: Text('فایل با موفقیت ایجاد و در دانلود ها ذخیره شد.')),
        // ));
        // Navigator.pop(context);
        // }
        return 1;
      } catch (e) {
        print('error : $e');
        return 0;
        // Navigator.pop(context);
        //
        // Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Directionality(
        //       textDirection: TextDirection.rtl,
        //       child: Text('خطا حین پشتیبان گیری'))),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            GridView.count(crossAxisSpacing: 16, crossAxisCount: 2, children: [
          _ItemsSetting(
            themeData: themeData,
            title: 'تغییر نام',
            icon: Icons.person,
            onTop: () {
              dialogChangeName(context, themeData);
              print('object');
            },
          ),
          _ItemsSetting(
            themeData: themeData,
            title: 'دریافت نسخه پشتبانی',
            icon: Icons.backup,
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
            title: 'حذف حساب افراد',
            icon: Icons.delete_sweep_outlined,
            onTop: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => RemoveAccounts(),
                  ));
            },
          ),_ItemsSetting(
            themeData: themeData,
            title: 'درباره ما',
            icon: Icons.account_box_rounded,
            onTop: () {

            },
          ),
        ]),
        // Column(
        //   children: [
        //
        //     InkWell(
        //       onTap: () {
        //         dialogChangeName(context, themeData);
        //       },
        //       child: Container(
        //         height: 80,
        //         width: double.infinity,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(15),
        //             gradient: LinearGradient(colors: [
        //               Colors.blue,
        //               Colors.blueAccent,
        //             ])),
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Icon(
        //                 Icons.person,
        //                 color: Colors.white,
        //                 size: 40,
        //               ),
        //               Text(
        //                 'تغییر نام',
        //                 style: themeData.textTheme.headline3!
        //                     .copyWith(color: Colors.white, fontSize: 18),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 15,
        //     ),
        //     InkWell(
        //       onTap: () async {
        //         var statusstorage = await Permission.storage.status;
        //         // اگر مجوز داده نشده، درخواست مجوز کنید
        //         if (!statusstorage.isGranted) {
        //           await Permission.storage.request();
        //         } else {
        //           try {
        //             // String? selectedDirectory =
        //             //     await FilePicker.platform.getDirectoryPath();
        //             // //final directory = await getApplicationDocumentsDirectory();
        //
        //             // if (selectedDirectory == null) {
        //             //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //             //     content: Directionality(
        //             //         textDirection: TextDirection.rtl,
        //             //         child: Text('پشتیبان گیری لغو شد.')),
        //             //   ));
        //             // } else {
        //             showAlertDialog(context, 'لطفا صبر کنید');
        //
        //             //گرفتن اطلاعات دیتابیس
        //             final boxtrx = Hive.box<Transactions>('Transactions');
        //             final boxacc = await Hive.box<Accounts>('Accounts');
        //             final boxdatauser = Hive.box<DataUser>('User');
        //
        //             List<Map<String, dynamic>> accountslist = [];
        //             for (var data in boxacc.values) {
        //               Map<String, dynamic> newaccmap = {
        //                 'id': data.id,
        //                 'name': data.name,
        //               };
        //               accountslist.add(newaccmap);
        //             }
        //
        //             List<Map<String, dynamic>> transactionslist = [];
        //             for (var data in boxtrx.values) {
        //               Map<String, dynamic> newtrxmap = {
        //                 'id': data.id,
        //                 'description': data.description,
        //                 'price': data.price,
        //                 'date': data.date,
        //                 'time': data.time,
        //                 'status': data.status
        //               };
        //               transactionslist.add(newtrxmap);
        //             }
        //
        //             Map<String, dynamic> user = {
        //               'name': boxdatauser.values.toList()[0].name
        //             };
        //
        //             // تبدیل به جیسون
        //             Map<String, dynamic> jsonData = {
        //               'transactions': transactionslist,
        //               'accounts': accountslist,
        //               'user': user,
        //             };
        //
        //             String jsonString = jsonEncode(jsonData);
        //
        //             //get data andtime to set file name
        //             var now = new DateTime.now();
        //             Gregorian g = Gregorian(now.year, now.month, now.day);
        //
        //             String temptime = now.hour.toString() +
        //                 '-' +
        //                 now.minute.toString() +
        //                 '-' +
        //                 now.second.toString();
        //
        //             String tempdate = g.toJalali().year.toString() +
        //                 '-' +
        //                 g.toJalali().month.toString() +
        //                 '-' +
        //                 g.toJalali().day.toString();
        //             String filename = tempdate + '-' + temptime;
        //
        //             List<int> bytes = jsonString.codeUnits;
        //             saveFile(filename, bytes);
        //
        //             // final file =
        //             //     File(selectedDirectory + '/' + filename + '.txt');
        //             // await file.writeAsString(jsonString,
        //             //     mode: FileMode.write, encoding: utf8);
        //
        //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //               content: Directionality(
        //                   textDirection: TextDirection.rtl,
        //                   child: Text('فایل با موفقیت ایجاد و در دانلود ها ذخیره شد.')),
        //             ));
        //             Navigator.pop(context);
        //             // }
        //           } catch (e) {
        //             print('error : $e');
        //             Navigator.pop(context);
        //
        //             Navigator.pop(context);
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(content: Directionality(
        //                   textDirection: TextDirection.rtl,
        //                   child: Text('خطا حین پشتیبان گیری'))),
        //             );
        //           }
        //         }
        //       },
        //       child: Container(
        //         height: 80,
        //         width: double.infinity,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(15),
        //             gradient: LinearGradient(colors: [
        //               Color(0xFF1F8307),
        //               Color(0xFF2AE101),
        //             ])),
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Icon(
        //                 Icons.backup,
        //                 color: Colors.white,
        //                 size: 40,
        //               ),
        //               Text(
        //                 'دریافت نسخه پشتبانی',
        //                 style: themeData.textTheme.headline3!
        //                     .copyWith(color: Colors.white, fontSize: 18),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 15,
        //     ),
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => RemoveAccounts(),
        //             ));
        //       },
        //       child: Container(
        //         height: 80,
        //         width: double.infinity,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(15),
        //             gradient: LinearGradient(colors: [
        //               Colors.red,
        //               Colors.redAccent,
        //             ])),
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Icon(
        //                 Icons.delete_sweep_outlined,
        //                 color: Colors.white,
        //                 size: 40,
        //               ),
        //               Text(
        //                 'حذف حساب افراد',
        //                 style: themeData.textTheme.headline3!
        //                     .copyWith(color: Colors.white, fontSize: 18),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
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
        child: Center(child: Text('فرم تغییر نام'))),
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
            maxLength: 8,
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
      height: 43,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: themeData.colorScheme.secondary.withOpacity(0.3),
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
  final IconData icon;
  final Function() onTop;

  const _ItemsSetting(
      {super.key,
      required this.themeData,
      required this.title,
      required this.icon,
      required this.onTop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTop(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 130,
          height: 180,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              //border: Border.all(color: Colors.deepPurple,width: 2),
              boxShadow: [
                BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2), blurRadius: 15)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 65,
                color: Colors.deepPurple,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: themeData.textTheme.headline3!.copyWith(
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
