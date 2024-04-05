import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {},
        child: Container(
          width: 150,
          height: 60,
          decoration: BoxDecoration(
              color: themeData.primaryColor,
              borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'افزودن یادآوری',
                  style: themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
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
      ),
      backgroundColor: themeData.colorScheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: themeData.colorScheme.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ساعت : 10:00:00'),
                      Text('تاریخ : 1403/01/21'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('عنوان : حقوق گرفته'),
                      Text('تاریخ ثبت یاد آور : 1403/01/03'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
