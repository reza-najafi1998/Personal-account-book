import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment/data/data.dart';
import 'package:payment/main.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/register.dart';



class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final box = Hive.box<DataUser>('User');
    if (box.values.length > 0) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) => MainScreen()));
      });
    }else{
      Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=> Register()));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: Center(
            child: Directionality(
      textDirection: TextDirection.rtl,
      child: Text('لطفا صبر کنید...', style: theme.textTheme.subtitle1),
    )));
  }
}
