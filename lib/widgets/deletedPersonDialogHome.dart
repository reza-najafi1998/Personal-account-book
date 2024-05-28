import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';

class DeletedPersonDialogHome extends StatelessWidget {

  final Accounts accitem;
  final String name;

   DeletedPersonDialogHome({Key? key, required this.accitem, required this.name}) : super(key: key);


  final boxtrx = Hive.box<Transactions>('Transactions');
  final boxacc = Hive.box<Accounts>('Accounts');
  final boxdatauser = Hive.box<DataUser>('User');
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
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Center(child: Text('حذف حساب'))),
      //actionsAlignment: MainAxisAlignment.start,
      titleTextStyle: themeData.textTheme.headline3!
          .copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      actions: [
        Container(
            height: 40,
            decoration: BoxDecoration(
                color: themeData.colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(name,style: themeData.textTheme.subtitle1,),
                SizedBox(
                  width: 8,
                ),
                Image.asset(
                  'assets/images/png/user.png',
                  width: 30,
                ),
                SizedBox(
                  width: 8,
                )
              ],
            )),
        SizedBox(
          height: 16,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: themeData.colorScheme.onTertiary,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'با حذف حساب تمام تراکنش ها حذف و\nغیر قابل بازگردانی خواهد شد.',
                    style: themeData.textTheme.headline3!
                        .copyWith(fontSize: 15, color: Colors.black),
                  ),
                ],
              )),
        ),
        TextButton(
            onPressed: () async {
              for (var data in boxtrx.values) {
                if (data.id == accitem.id) {
                  await data.delete();
                }
              }
              await accitem.delete();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text('حساب با موفقیت حذف شد')),
              ));
              Navigator.pop(context);
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
  }
}
