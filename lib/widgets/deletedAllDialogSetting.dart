import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/splash.dart';

class DeletedAllDialogSetting extends StatelessWidget {

  final boxtrx = Hive.box<Transactions>('Transactions');
  final boxacc = Hive.box<Accounts>('Accounts');
  final boxdatauser = Hive.box<DataUser>('User');

  TextEditingController _text=TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Center(child: Text('حذف حساب کاربری')),
      ),
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(Icons.delete_forever_rounded,color: Colors.red,size: 65,),
          Container(
            decoration: BoxDecoration(
                color: themeData.colorScheme.secondary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'با حذف حساب کاربری تمام اطلاعات شما حذف و غیر قابل بازگردانی خواهد شد.',
                          style: TextStyle(fontSize: 12),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.error,
                      color: themeData.colorScheme.error,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8,),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(fontSize: 13),
                controller: _text,
                maxLength: 5,
                textAlign: TextAlign.right,
                decoration: InputDecoration(

                    label: Text('بنویسید تایید'),
                    counterText: "",
                    //prefixIcon: Icon(CupertinoIcons.text_alignright),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async{
                  if(_text.text=='تایید'){
                   await boxtrx.clear();
                   await boxdatauser.clear();
                   await boxacc.clear();
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen(),));
                  }

                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.error,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'حذف حساب',
                        style: themeData.textTheme.headline3!
                            .copyWith(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
