import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment/screens/reminder.dart';
import 'package:payment/screens/setting.dart';

class MyDrawer extends StatelessWidget{
  final String nameUser;

  const MyDrawer({super.key, required this.nameUser});
  @override
  Widget build(BuildContext context) {
    var themeData=Theme.of(context);
    return Container(
      width: 220,
      height: double.infinity,
      color: themeData.colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.lightBlueAccent.withOpacity(0.3),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 64, 16, 8),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(85),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10)
                              ]),
                          child: Image.asset(
                            'assets/images/png/user.png',
                            scale: 2,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'کاربر : $nameUser',
                        style: themeData.textTheme.subtitle1,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Reminder(),));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'مدیریت نوتیفیکیشن ها',
                        style:
                        themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.notifications_none)
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Colors.black.withOpacity(0.6),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Settingpage(),));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تنظیمات',
                        style:
                        themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.settings)
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Colors.black.withOpacity(0.6),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'درباره ما',
                      style:
                      themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.supervised_user_circle_sharp),
                  ],
                ),
              ),
            ],
          ),
          Text('v 1.0.0')
        ],
      ),
    );
  }

}
