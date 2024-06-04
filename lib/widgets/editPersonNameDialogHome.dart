import 'package:flutter/material.dart';
import 'package:payment/data/data.dart';

import '../screens/home.dart';

class EditPersonNameDialogHome extends StatefulWidget {
  final Accounts accitem;

  const EditPersonNameDialogHome({super.key, required this.accitem});

  @override
  _EditPersonNameDialogHomeState createState() =>
      _EditPersonNameDialogHomeState();
}

class _EditPersonNameDialogHomeState extends State<EditPersonNameDialogHome> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _name.text = widget.accitem.name;
    _phone.text = widget.accitem.phone;
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
                _name.selection = TextSelection.fromPosition(
                    TextPosition(offset: _name.text.length));
              },
              controller: _name,
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
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: TextField(
              onTap: () {
                _phone.selection = TextSelection.fromPosition(
                    TextPosition(offset: _phone.text.length));
              },
              controller: _phone,
              maxLength: 11,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  counterText: "",
                  label: Text('ویرایش شماره تلفن'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              if (_name.text.isNotEmpty) {
                if (widget.accitem.name != _name.text) {
                  widget.accitem.name = _name.text;
                  widget.accitem.phone = _phone.text;
                  await widget.accitem.save();
                  Navigator.pop(context, true);
                } else if (widget.accitem.phone != _phone.text) {
                  widget.accitem.name = _name.text;
                  widget.accitem.phone = _phone.text;
                  await widget.accitem.save();
                  Navigator.pop(context, true);
                }else {
                  Navigator.pop(context, false);
                }

                //SystemNavigator.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
