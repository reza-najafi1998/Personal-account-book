import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveAgainCoachDialog extends StatelessWidget {
  @override
  late SharedPreferences prefs;

  Future<void> setdata() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('CoachHome', true);
    prefs.setBool('CoachListhesab', true);
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
          child: Center(child: Text('فعال کردن مجدد آموزش'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        Column(
          children: [
            SvgPicture.asset(
              'assets/images/svgs/learning.svg',
              width: 80,
            ),SizedBox(height: 16,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'بعد از فعال کردن آموزش ، برنامه بسته خواهد شد.',
                style: themeData.textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                setdata();
                SystemNavigator.pop();
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
