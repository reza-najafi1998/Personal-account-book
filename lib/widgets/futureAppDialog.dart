import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/widgets/sortedDialogHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FutureAppDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SelectedValues selectedValues =
        SelectedValues(selectedAccordingValue: true, selectedAsValue: false);
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
          child: Center(child: Text('تایم لاین امکانات اپلیکیشن'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        Column(
          children: [

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'مدیریت بستانکاری و بدهکاری',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAccordingValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'افزودن یادآور به طرف حساب',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAccordingValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ' انتخاب طرف حساب از مخاطبین',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAccordingValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ایجاد امکان پشتیبان گیری آنلاین',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAsValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ثبت چک و اقساط بانکی',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAsValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'مدیرت و گزارش گیری دخل و خرج',
                      style:
                          themeData.textTheme.subtitle1!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio(
                        value: true,
                        toggleable: true,
                        activeColor: themeData.colorScheme.primary,
                        groupValue: selectedValues.selectedAsValue,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
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
                'خب',
                style: themeData.textTheme.subtitle2!.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ],
    );
  }
}
