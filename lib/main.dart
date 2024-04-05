import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/splash.dart';

const userBoxName='User';
const userBoxTransactions='Transactions';
const userBoxAccounts='Accounts';
void main() async{
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

const String fontName='IRANSans';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

    scaffoldBackgroundColor:const  Color(0xfff4f1f1),
        colorScheme: const ColorScheme.light(
          primary :  Color(0xff00aeff),
          onPrimary: Colors.white,
          secondary: Color(0xffb8b8b8) ,
          onSecondary: Colors.black
        ),
        textTheme: TextTheme(
          subtitle2: TextStyle(fontFamily: fontName,fontSize: 17,color:Theme.of(context).colorScheme.onPrimary ),
          subtitle1: TextStyle(fontFamily: fontName,fontSize: 17,color:Colors.black ),
          headline3: TextStyle(fontFamily: fontName,fontSize: 14)
        ),
    snackBarTheme: SnackBarThemeData(contentTextStyle: TextStyle(fontFamily: fontName,),)

    ),
      home:  SplashScreen(),
    );
  }
}

