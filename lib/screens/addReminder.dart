import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;

import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/services/notif_service.dart';
import 'package:payment/services/time_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';

final timeFormatter = intl.DateFormat('HH:mm:ss');
final DateTime now = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
String jalaliselected =
    '${Jalali.now().year}/${fixmonthdate(Jalali.now().month.toString())}/${Jalali.now().day}';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key, required this.id});

  final int id;

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController _nameTxt = TextEditingController();
  final TextEditingController _infoTxt = TextEditingController();
  var settime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  final box = Hive.box<Accounts>('Accounts');

  @override
  void initState() {
    settime =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    _nameTxt.text = box.values
        .toList()
        .firstWhere((element) => element.id == widget.id)
        .name;
    super.initState();
  }

  // class _AddTransaction extends State<AddTransaction> {

  // void toggleSwitch(bool value) {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Accounts>('Accounts');
    // _nameTxt.text=box.values.toList()[widget.trx.id-1].name;
    final themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'فرم ثبت یادآور',
                style: themeData.textTheme.subtitle1!.copyWith(fontSize: 23),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _nameTxt,
                    enabled: false,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.switch_account),
                        label: const Text('نام حساب'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _infoTxt,
                    maxLength: 60,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        label: Text('توضیحات'),
                        prefixIcon: Icon(CupertinoIcons.text_alignright),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showDateDialog(
                    context,
                    themeData,
                    jalaliselected,
                    (dateselected) {
                      setState(() {
                        jalaliselected = dateselected;
                      });
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: themeData.colorScheme.secondary)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                          child: Text(
                            jalaliselected.toPersianDigit(),
                            style: themeData.textTheme.subtitle1,
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                'انتخاب تاریخ مورد نظر',
                                style: themeData.textTheme.headline3!
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.date_range_rounded,
                              color: Color(0xff8d8c8c),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  //width: 170,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18),
                              topLeft: Radius.circular(18),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                '${fixmonthdate(settime.hour.toString())} : ${fixmonthdate(settime.minute.toString())}'
                                    .toPersianDigit(),
                                style: themeData.textTheme.subtitle1!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    'انتخاب زمان :',
                                    style: themeData.textTheme.headline3!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                // Image.asset(
                                //   'assets/images/png/time.png',
                                //   width: 45,
                                // ),
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 16,
                      ),
                      TimePickerSpinner(
                        locale: const Locale('en', ''),
                        time: now,
                        is24HourMode: true,
                        isShowSeconds: false,
                        itemHeight: 40,
                        itemWidth: 30,
                        normalTextStyle: themeData.textTheme.subtitle1,
                        highlightedTextStyle: themeData.textTheme.subtitle1,
                        // const TextStyle(fontSize: 24, color: Colors.blue),
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            settime =
                                TimeOfDay(hour: time.hour, minute: time.minute);
                          });
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () async {

                  Jalali x = jalaliselected.length==9?Jalali(
                      int.parse(jalaliselected.substring(0, 4)),
                      int.parse(jalaliselected.substring(5, 7)),
                      int.parse(jalaliselected.substring(8, 9))):
                  Jalali(
                      int.parse(jalaliselected.substring(0, 4)),
                      int.parse(jalaliselected.substring(5, 7)),
                      int.parse(jalaliselected.substring(8, 10)));

                  Gregorian miladidate = x.toGregorian();
                  DateTime scheduleTime = DateTime(
                      miladidate.year,
                      miladidate.month,
                      miladidate.day,
                      settime.hour,
                      settime.minute,
                      0,
                      0,
                      0);
                  DateTime datenow = DateTime.now();

                  int checktime = datenow.compareTo(scheduleTime);

                  if (checktime < 0) {
                    NotificationService().scheduleNotification(
                        id: widget.id,
                        title:'یادآور حساب '+ _nameTxt.text,
                        body: _infoTxt.text,
                        payLoad: scheduleTime.toString(),
                        scheduledNotificationDateTime: scheduleTime);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('یادآور با موفقیت ثبت شد.')),
                    ));
                    Navigator.pop(context);
                  } else if (checktime > 0) {
                    // $scheduleTime < datetime.now
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                    ));
                  }

                  // if(scheduleTime.year>=datenow.year){
                  //   if(scheduleTime.month>=datenow.month){
                  //     if(scheduleTime.day>=datenow.day){
                  //
                  //       int orgtime = (settime.hour *60)+settime.minute;
                  //       int nowtime = (DateTime.now().hour *60)+DateTime.now().minute;
                  //
                  //       if (scheduleTime.year>datenow.year|| scheduleTime.month>=datenow.month || scheduleTime.day>=datenow.day && orgtime>nowtime) {
                  //         NotificationService().scheduleNotification(
                  //             id: widget.id,
                  //             title:_nameTxt.text+ ' یاد آوری حساب ',
                  //             body: _infoTxt.text,
                  //             payLoad: scheduleTime.toString(),
                  //             scheduledNotificationDateTime: scheduleTime);
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //           content: Directionality(
                  //               textDirection: TextDirection.rtl,
                  //               child: Text(
                  //                   'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                  //         ));
                  //       }
                  //     }else{
                  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //         content: Directionality(
                  //             textDirection: TextDirection.rtl,
                  //             child: Text(
                  //                 'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                  //       ));
                  //     }
                  //   }else{
                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //       content: Directionality(
                  //           textDirection: TextDirection.rtl,
                  //           child: Text(
                  //               'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                  //     ));
                  //   }
                  // }else{
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Directionality(
                  //         textDirection: TextDirection.rtl,
                  //         child: Text(
                  //             'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                  //   ));
                  // }
                  //showAlertDialog(context, 'لطفا صبر کنید');
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 227,
                  height: 50,
                  decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    'ثبت',
                    style: themeData.textTheme.subtitle2,
                  ),
                ),
              ),
            ],
          ),
        ),
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

typedef setdate = void Function(String dateselected);

showDateDialog(BuildContext context, ThemeData themeData, String jalaliNowDate,
    setdate onsetdateselected) {
  String selectdatejalali = '';
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
        child: Center(child: Text('تاریخ را انتخاب کنید'))),
    //actionsAlignment: MainAxisAlignment.start,
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),
    actions: [
      SizedBox(
        height: 16,
      ),
      LinearDatePicker(
          endDate: "1408/12/29",
          initialDate: jalaliNowDate,
          addLeadingZero: true,
          dateChangeListener: (String selectedDate) {
            selectdatejalali = selectedDate;
          },
          showDay: true,
          //false -> only select year & month
          labelStyle: TextStyle(
            fontFamily: 'IRANSans',
            fontSize: 14.0,
            color: Colors.black,
          ),
          selectedRowStyle: TextStyle(
            fontFamily: 'IRANSans',
            fontSize: 18.0,
            color: Colors.deepOrange,
          ),
          unselectedRowStyle: TextStyle(
            fontFamily: 'IRANSans',
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
          yearText: "سال",
          monthText: "ماه",
          dayText: "روز",
          showLabels: true,
          // to show column captions, eg. year, month, etc.
          columnWidth: 80,
          showMonthName: true,
          isJalaali: true // false -> Gregorian
          ),
      TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            onsetdateselected(selectdatejalali);
            Navigator.pop(context);
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

String fixmonthdate(String month) {
  if (month.length <= 1) {
    return '0' + month;
  } else {
    return month;
  }
}
