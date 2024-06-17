import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/services/saveFile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupLocalDialog extends StatelessWidget {
  @override
  Future<int> _createBackup() async {
    //return => 0 error
    //return => 1 ok
    //return => 2 Permission
    bool isGranted = await Permission.storage.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }
    if (isGranted) {
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
    }else{
      return 2;
    }

    // var statusstorage = await Permission.storage.status;
    // // اگر مجوز داده نشده، درخواست مجوز کنید
    // if (!statusstorage.isGranted) {
    //   await Permission.storage.request();
    //   return 2;
    // } else
    // {
    //
    // }
  }


  @override
  Widget build(BuildContext context) {
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
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Center(child: Text('ذخیره فایل پشتیبانی'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        Column(
          children: [
            SvgPicture.asset(
              'assets/images/svgs/backup.svg',
              width: 80,
            ),SizedBox(height: 16,),
            Container(
              decoration: BoxDecoration(
                color: themeData.colorScheme.secondary,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'فایل پشتیبانی در پوشه دانلود ها (Downloads) ذخیره خواهد شد.',
                    style: themeData.textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async{
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    themeData.colorScheme.primaryContainer),
                // رنگ پس‌زمینه
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  EdgeInsets.fromLTRB(16, 8, 16, 8), // فضای داخلی دکمه
                ),
              ),
              child: Text(
                'ذخیره',
                style: themeData.textTheme.subtitle2!.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ],
    );
  }
}
