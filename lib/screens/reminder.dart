import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/addReminder.dart';
import 'package:payment/services/notift_getlist.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

//List<PendingNotificationRequest> pendingNotifications = [];

NotificationHelper notificationHelper = NotificationHelper();

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  ValueNotifier<List<PendingNotificationRequest>> pendingNotifications =
      ValueNotifier<List<PendingNotificationRequest>>([]);

  bool issort = true;

  @override
  void initState() {
    super.initState();
    notificationHelper.initialize();
    // Retrieve pending notifications when the widget is initialized
    _retrievePendingNotifications();
  }

  // Function to retrieve pending notifications
  Future<void> _retrievePendingNotifications() async {
    // Get pending notifications using the NotificationHelper instance
    List<PendingNotificationRequest> notifications =
        await notificationHelper.getPendingNotifications();
    setState(() {
      pendingNotifications.value = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _retrievePendingNotifications();
    });
    // final boxtrx = Hive.box<Transactions>('Transactions');
    // final boxacc = Hive.box<Accounts>('Accounts');
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لیست یادآور های در انتظار',
                    style: themeData.textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _retrievePendingNotifications();
                        });
                      },
                      child: Icon(Icons.notifications_active_outlined))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      child: ValueListenableBuilder(
                          // گوش دادن به تغییرات در ValueNotifier
                          valueListenable: pendingNotifications,
                          builder: (context, notifications, child) {
                            return pendingNotifications.value.isNotEmpty
                                ? ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        pendingNotifications.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Itemlist(
                                        themeData: themeData,
                                        titleNotify: pendingNotifications
                                            .value[index].title
                                            .toString(),
                                        bodyNotify: pendingNotifications
                                            .value[index].body
                                            .toString(),
                                        payloadNotify: pendingNotifications
                                            .value[index].payload
                                            .toString(),
                                        personid: pendingNotifications
                                            .value[index].id,
                                        onDelete: (int id) {
                                          setState(() {
                                            notificationHelper
                                                .cancelNotification(
                                                    pendingNotifications
                                                        .value[index].id);
                                            pendingNotifications.value
                                                .removeWhere((notification) =>
                                                    notification.id == id);
                                            Navigator.pop(context);
                                          });
                                        },
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 64),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/png/empty_list.png',
                                          scale: 2,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'یادآوری یافت نشد.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ))
                                      ],
                                    ),
                                  );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

typedef DeleteCallback = void Function(int id);

class Itemlist extends StatelessWidget {
  final ThemeData themeData;
  final int personid;
  final String titleNotify;
  final String bodyNotify;
  final DeleteCallback onDelete;

  //datetime set in payload as string
  final String payloadNotify;

  const Itemlist(
      {super.key,
      required this.themeData,
      required this.titleNotify,
      required this.bodyNotify,
      required this.payloadNotify,
      required this.personid,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    //final box = Hive.box<Accounts>('Accounts');

    DateTime notifydatetimemiladi = DateTime(
      int.parse(payloadNotify.substring(0, 4)),
      int.parse(payloadNotify.substring(5, 7)),
      int.parse(payloadNotify.substring(8, 10)),
      int.parse(payloadNotify.substring(11, 13)),
      int.parse(payloadNotify.substring(14, 16)),
    );

    TimeOfDay notifyTime = TimeOfDay(
        hour: notifydatetimemiladi.hour, minute: notifydatetimemiladi.minute);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 115,
        decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                deletenotify(context, themeData, personid, titleNotify,notifydatetimemiladi,notifyTime);
              },
              child: Container(
                width: 50,
                //height:10,
                decoration: BoxDecoration(
                    color: themeData.colorScheme.error,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.delete_solid,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        'حذف',
                        style: themeData.textTheme.headline3!
                            .copyWith(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 180
                        ,child: Directionality(
                        textDirection: TextDirection.rtl,
                          child: Text(
                            titleNotify,
                            overflow: TextOverflow.ellipsis
                            ,style: themeData.textTheme.subtitle1!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                      Text(' : عنوان',
                          style: themeData.textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: themeData.colorScheme.secondary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                            width: 270,
                            child: Text(
                              bodyNotify != ''
                                  ? 'توضیحات : ' + bodyNotify
                                  : 'توضیحات : ندارد!',
                              style: themeData.textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            notifydatetimemiladi.toPersianDate(),
                            style: themeData.textTheme.subtitle1!
                                .copyWith(fontSize: 11),
                          ),
                          Text(
                            ' : تاریخ',
                            style: themeData.textTheme.subtitle1!
                                .copyWith(fontSize: 12),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.date_range_outlined,
                            size: 18,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            fixmonthdate(notifyTime.hour.toString()) +
                                " : " +
                                fixmonthdate(notifyTime.minute.toString()),
                            style: themeData.textTheme.subtitle1!
                                .copyWith(fontSize: 12),
                          ),
                          Text(
                            ' : ساعت',
                            style: themeData.textTheme.subtitle1!
                                .copyWith(fontSize: 12),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            size: 18,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deletenotify(
      BuildContext context, ThemeData themeData, int id, String title,DateTime datetime,TimeOfDay timeof) {
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
          child: Center(child: Text('حذف یاد آور'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        SizedBox(
          height: 16,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: [

                  Text(
                    'شما در حال حذف یادآور با مشخصات زیر هستید.',
                    style: themeData.textTheme.headline3!
                        .copyWith(fontSize: 15, color: Colors.black),
                  ),
                  Text(
                    ' عنوان : $title',
                    style: themeData.textTheme.headline3!
                        .copyWith(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' زمان : '+fixmonthdate(timeof.hour.toString())+':'+fixmonthdate(timeof.minute.toString())+'  '+datetime.toPersianDate(),
                    style: themeData.textTheme.headline3!
                        .copyWith(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
        TextButton(
            onPressed: () async {
              onDelete(personid);

              // notificationHelper.cancelNotification(personid);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text('یادآور با موفقیت حذف شد')),
              ));
            },
            child: Container(
                //height: 50,
                //width: 150,
                decoration: BoxDecoration(
                    color: themeData.colorScheme.error,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'حذف',
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
}

String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }

  return input;
}
