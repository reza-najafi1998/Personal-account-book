import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;


import 'package:payment/data/data.dart';
import 'package:payment/services/notif_service.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

// var nowdate = new DateTime.now();
// var formatter = new intl.DateFormat('yyyy-MM-dd');
// Gregorian g = Gregorian(nowdate.year, nowdate.month, nowdate.day);
//


final timeFormatter = intl.DateFormat('HH:mm:ss');
final DateTime now = DateTime.now();


String _jalalidate =
    '${Jalali.now().year}/${Jalali.now().month}/${Jalali.now().day}';
String _time =timeFormatter.format(now);

class AddReminder extends StatefulWidget {
  const AddReminder({super.key, required this.id});

  final int id;

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController _nameTxt = TextEditingController();
  final TextEditingController _infoTxt = TextEditingController();
  Jalali jalaliselected = Jalali.now();
  var settime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  final box = Hive.box<Accounts>('Accounts');



  @override
  void initState() {
    _nameTxt.text=box.values.toList().firstWhere((element) => element.id==widget.id).name;
    print(_jalalidate);
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
                    maxLength: 150,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        label: Text('توضیحات'),
                        prefixIcon: Icon(CupertinoIcons.text_alignright),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            jalaliselected = (await showPersianDatePicker(
                              context: context,
                              initialDate: Jalali.now(),
                              firstDate: Jalali(Jalali.now().year,
                                  Jalali.now().month, Jalali.now().day),
                              lastDate: Jalali(Jalali.now().year + 10, 12),
                            ))!;
                            setState(() {
                              final picked = this.jalaliselected;
                              if (picked != null) {
                                _jalalidate = picked.year.toString() +
                                    '/' +
                                    picked.month.toString() +
                                    '/' +
                                    picked.day.toString();
                              }
                            });
                          },
                          child: Text(
                            'تنظیم تاریخ',
                            style: themeData.textTheme.headline3!
                                .copyWith(color: Colors.white),
                          )),
                      Row(
                        children: [
                          Text(
                            'تاریخ : ' + _jalalidate,
                            style: themeData.textTheme.headline3!
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Image.asset(
                            'assets/images/png/calender.png',
                            width: 45,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            settime = (await showPersianTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),

                            ))!;
                            setState(() {
                              _time = settime.hour.toString() +
                                  ':' +
                                  settime.minute.toString();
                            });
                          },
                          child: Text(
                            'تنظیم ساعت',
                            style: themeData.textTheme.headline3!
                                .copyWith(color: Colors.white),
                          )),
                      Row(
                        children: [
                          Text(
                            'ساعت : ' + _time,
                            style: themeData.textTheme.headline3!
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Image.asset(
                            'assets/images/png/time.png',
                            width: 45,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {



                  //showAlertDialog(context, 'لطفا صبر کنید');
                  int orgtime = (settime.hour *60)+settime.minute;
                  int nowtime = (DateTime.now().hour *60)+DateTime.now().minute;


                  if (orgtime>nowtime) {
                    Gregorian  miladidate=jalaliselected.toGregorian();
                    DateTime scheduleTime=DateTime(miladidate.year,miladidate.month,miladidate.day,settime.hour,settime.minute,0,0,0);


                    NotificationService().scheduleNotification(
                      id: widget.id,
                        title:_nameTxt.text+ ' یاد آوری حساب ',
                        body: _infoTxt.text,
                        payLoad: scheduleTime.toString(),
                        scheduledNotificationDateTime: scheduleTime);

                    // NotificationService().showNotification(body: 'sss',title: 'sdsd', id: 15);

                    // final transactions = Transactions();
                    //
                    // Navigator.of(context).pop();
                    //
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Directionality(
                    //       textDirection: TextDirection.rtl,
                    //       child: Text('مقادیر خالی است')),
                    // ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              'برای ثبت یاد آور زمانی در آینده انتخاب کنید.')),
                    ));
                  }
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

//   @override
//   Widget build(BuildContext context) {

//   }
// }

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
