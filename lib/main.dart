import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/reminder.dart';
import 'package:payment/screens/setting.dart';
import 'package:payment/screens/splash.dart';
import 'package:payment/services/notif_service.dart';
import 'package:timezone/data/latest.dart' as tz;

const userBoxName = 'User';
const userBoxTransactions = 'Transactions';
const userBoxAccounts = 'Accounts';

void main() async {
  //---notify setting
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
//-------------
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);

  await Hive.initFlutter();
  Hive.registerAdapter(DataUserAdapter());
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter(AccountsAdapter());
  await Hive.openBox<DataUser>(userBoxName);
  await Hive.openBox<Transactions>(userBoxTransactions);
  await Hive.openBox<Accounts>(userBoxAccounts);
  runApp(const MyApp());
}

const String fontName = 'IRANSans';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xfff4f1f1),
          colorScheme: const ColorScheme.light(
              primary: Color(0xff00aeff),
              onPrimary: Colors.white,
              secondary: Color(0xffb8b8b8),
              onSecondary: Colors.black),

          textTheme: TextTheme(
              //headlineSmall: TextStyle(fontFamily: fontName,fontSize: 14),
              subtitle2: TextStyle(
                  fontFamily: fontName,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onPrimary),
              subtitle1: TextStyle(
                  fontFamily: fontName, fontSize: 17, color: Colors.black),
              headline3: TextStyle(fontFamily: fontName, fontSize: 14)),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: TextStyle(
              fontFamily: fontName,
            ),
          )),
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int menuIndex = 0;
const int homeIndex = 1;
const int settingIndex = 2;

class _MainScreenState extends State<MainScreen> {
  int selectedPageIndex = homeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottonNavigiton(
        onTop: (int index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        pageselected: selectedPageIndex,
      ),
      body: IndexedStack(
        index: selectedPageIndex,
        children: [
          Reminder(),
          Home(),
          Settingpage(),
        ],
      ),
    );
  }
}

class _BottonNavigiton extends StatelessWidget {
  final Function(int index) onTop;
  final int pageselected;

  const _BottonNavigiton(
      {super.key, required this.onTop, required this.pageselected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
        ],
      ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ItemBottonNavigition(
              iconpath: 'menu.svg',
              active: pageselected == menuIndex ? true : false,
              onTop: () {
                onTop(menuIndex);
              }, title: 'یاد آور ها',
            ),
            _ItemBottonNavigition(
              iconpath: 'home.svg',
              active: pageselected == homeIndex ? true : false,
              onTop: () {
                onTop(homeIndex);
              }, title: 'صفحه اصلی',
            ),
            _ItemBottonNavigition(
              iconpath: 'settings.svg',
              active: pageselected == settingIndex ? true : false,
              onTop: () {
                onTop(settingIndex);
              }, title: 'تنظیمات',
            ),
            // InkWell(
            //   onTap: () {
            //
            //   },
            //   child: SizedBox(
            //     width: 110,
            //     height: 40,
            //     child: Container(
            //       width: 40,
            //       height: 40,
            //       decoration: BoxDecoration(
            //           color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             'افزودن حساب',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .subtitle1!
            //                 .copyWith(color: Colors.white, fontSize: 12),
            //           ),
            //           Icon(
            //             Icons.add_circle_outline_rounded,
            //             color: Colors.white,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ItemBottonNavigition extends StatelessWidget {
  final String iconpath;
  final bool active;
  final Function() onTop;
  final String title;

  const _ItemBottonNavigition(
      {super.key,
      required this.iconpath,
      required this.active,
      required this.onTop, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300), // مدت زمان انیمیشن
              width: active ? 35 : 0, // عرض مورد نظر به جای 35
              height: 4,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset(
                'assets/images/svgs/$iconpath',
                width: 30,
                colorFilter: active
                    ? const ColorFilter.mode(Colors.deepPurple, BlendMode.srcIn)
                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                //semanticsLabel: 'A red up arrow'
              ),
            ),
            Visibility(
                visible: active?true:false,
                child: Text(title,style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.deepPurple,fontSize: 10),))
          ],
        ),
      ),
    );
  }
}
