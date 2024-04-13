import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payment/screens/addReminder.dart';
import 'package:payment/services/notift_getlist.dart';

class Reminder extends StatelessWidget {
  final int id;

  Reminder({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Initialize NotificationHelper
    NotificationHelper notificationHelper = NotificationHelper();
    notificationHelper.initialize();

    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddReminder(id: id)));
        },
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
            MyHomePage(notificationHelper: notificationHelper),
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

class MyHomePage extends StatefulWidget {
  final NotificationHelper notificationHelper;

  MyHomePage({required this.notificationHelper});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PendingNotificationRequest> pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    // Retrieve pending notifications when the widget is initialized
    _retrievePendingNotifications();
  }

  // Function to retrieve pending notifications
  Future<void> _retrievePendingNotifications() async {
    // Get pending notifications using the NotificationHelper instance
    List<PendingNotificationRequest> notifications =
        await widget.notificationHelper.getPendingNotifications();
    setState(() {
      pendingNotifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: ListView.builder(
        itemCount: pendingNotifications.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(pendingNotifications[index].title.toString()),
            subtitle: Text(':  ${pendingNotifications[index].payload}'),

          );
        },
      ),
    );
  }
}
