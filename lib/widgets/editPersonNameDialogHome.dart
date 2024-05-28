import 'package:flutter/material.dart';
import 'package:payment/data/data.dart';

class EditPersonNameDialogHome extends StatefulWidget {
final Accounts accitem;

  const EditPersonNameDialogHome({super.key, required this.accitem});

  @override
  _EditPersonNameDialogHomeState createState() => _EditPersonNameDialogHomeState();
}

class _EditPersonNameDialogHomeState extends State<EditPersonNameDialogHome> {
  TextEditingController controller = TextEditingController();

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
          child: Center(child: Text('فرم ویرایش حساب'))),
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
            child: TextField(
              onTap: () {
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              },
              controller: controller,
              maxLength: 30,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  counterText: "",
                  label: Text('ویرایش نام'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                if (widget.accitem.name != controller.text) {
                  widget.accitem.name = controller.text;
                  await widget.accitem.save();
                  Navigator.pop(context,true);
                } else {
                  Navigator.pop(context,false);
                }

                //SystemNavigator.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                  content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text('مقدار نام خالی است.')),
                ));
              }
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

  }
}
