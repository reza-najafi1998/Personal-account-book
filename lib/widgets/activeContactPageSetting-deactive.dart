import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveContactPageSetting extends StatefulWidget {
  @override
  State<ActiveContactPageSetting> createState() => _ActiveContactPageSettingState();
}
bool _Contactpage=true;

class _ActiveContactPageSettingState extends State<ActiveContactPageSetting> {
  late SharedPreferences prefs;



  Future<void> getdata() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _Contactpage = prefs.getBool('Contactpage')??true;
    });

  }

  Future<void> setdata() async {
    prefs.setBool('Contactpage', _Contactpage == true ? false : true);
  }

  @override
  void initState() {
    getdata();
    super.initState();
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
          child: Center(child: Text('فعال / غیر فعال کردن مخاطبین'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        Column(
          children: [
            Icon(
              Icons.perm_contact_cal_rounded,
              size: 55,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'برای افزودن طرف حساب می توانید از اسم و شماره تلفن مخاطبین استفاده کنید.',
                style: themeData.textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: themeData.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    _Contactpage?
                    'صفحه مخاطبین برای شما فعال است':
                    'صفحه مخاطبین برای شما غیر فعال است',
                    style: themeData.textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {
                setdata();
                Navigator.pop(context,true);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(_Contactpage?themeData.colorScheme.error:themeData.colorScheme.primaryContainer),
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
              child: Text(_Contactpage?
                'غیر فعال کردن':
                'فعال کردن',
                style: themeData.textTheme.subtitle2!.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ],
    );
  }
}
