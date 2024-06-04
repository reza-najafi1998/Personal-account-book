import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment/data/data.dart';
import 'package:payment/main.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/onBoarding.dart';
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
          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=> OnBoardingScreen()));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/png/onboarding/logo.png',
                scale: 2,
              ),
              SizedBox(
                height: 32,
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('هیچ طلبی فراموش نمیشه...',style: theme.textTheme.subtitle1,)),
              SizedBox(
                height: 32,
              ),SpinKitThreeBounce(
                size: 30,
                color: theme.colorScheme.primary,
              )
            ],
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('دفتر حساب 1.0.0', style: theme.textTheme.subtitle1),
          ),
        ),
      ],
    ));
  }
}
