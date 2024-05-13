import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart'as intl;
import 'package:payment/data/data.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import  'package:persian_number_utility/persian_number_utility.dart';

// import 'package:shamsi_date/shamsi_date.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.trx});
final Transactions trx;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool isswitch = true;



  final TextEditingController _nameTxt = TextEditingController();

  final TextEditingController _amountTxt = TextEditingController();

  final TextEditingController _infoTxt = TextEditingController();


  @override
  void initState() {
    _infoTxt.text=widget.trx.description;
    _amountTxt.text=widget.trx.price==0?'':widget.trx.price.toString().seRagham();
    isswitch=widget.trx.status;
    super.initState();
  }
  // class _AddTransaction extends State<AddTransaction> {


  // void toggleSwitch(bool value) {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Accounts>('Accounts');

    _nameTxt.text=box.values.toList().firstWhere((element) => element.id==widget.trx.id).name;
    final themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'فرم ثبت تراکنش جدید',
                style: themeData.textTheme.subtitle1!.copyWith(fontSize: 23),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(

                    controller: _nameTxt,
                    enabled: false,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.switch_account),
                        label: const Text('نام حساب'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'بدهکاری',
                    style: themeData.textTheme.subtitle1,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      // thumb color (round icon)
                      activeColor: themeData.colorScheme.primaryContainer,
                      activeTrackColor: Colors.black.withOpacity(0.3),
                      inactiveThumbColor: themeData.colorScheme.error,
                      inactiveTrackColor: Colors.grey.shade400,
                      //splashRadius: 50.0,
                      // boolean variable value
                      value: isswitch,
                      // changes the state of the switch
                      onChanged: (value) {
                        setState(() {
                          isswitch = !isswitch;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text('بستانکاری', style: themeData.textTheme.subtitle1),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      // print(value);
                      if(value.isNotEmpty && value.substring(0,1)=='0'){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text('عدد صفر ابتدای مبلغ درج نخواهد شد')),
                        ));
                      }
                    },
                    controller: _amountTxt,
                    maxLength: 15,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CustomAmountFormatter()],
                    decoration: InputDecoration(
                        label: Text('مبلغ حساب'),
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _infoTxt,
                    maxLength: 50,
                    textAlign: TextAlign.right,
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                        label: Text('توضیحات'),
                        prefixIcon: Icon(CupertinoIcons.text_alignright),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  showAlertDialog(context, 'لطفا صبر کنید');

                  String outputString = _amountTxt.text.replaceAll(',', ''); // حذف تمام ویرگول‌ها


                  if(outputString.isNotEmpty) {
                    final transactions = Transactions();
                    var now = new DateTime.now();
                    var formatter = new intl.DateFormat('yyyy-MM-dd');
                    Gregorian g = Gregorian(now.year, now.month, now.day);


                    widget.trx.status = isswitch;
                    widget.trx.price = int.parse(outputString);
                    widget.trx.description = _infoTxt.text;

                    final Box<Transactions> box = Hive.box('transactions');
                    if (widget.trx.isInBox) {
                      await widget.trx.save();
                    } else {
                       widget.trx.date = g
                          .toJalali()
                          .year
                          .toString() + '/' + g
                          .toJalali()
                          .month
                          .toString() + '/' + g
                          .toJalali()
                          .day
                          .toString();
                      widget.trx.time = now.hour.toString() + ':' + now.minute
                          .toString() + ':' + now.second.toString();
                      await box.add(widget.trx);
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('مقادیر خالی است')),
                    ));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 227,
                  height: 50,
                  decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    'ثبت',
                    style: themeData.textTheme.subtitle2,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {

//   }
// }

showAlertDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 150,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(textDirection: TextDirection.rtl, child: Text(text)),
          SizedBox(
            width: 8,
          ),
          CircularProgressIndicator(
            value: null,
            strokeWidth: 7.0,
          ),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class CustomAmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the new value
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Add a comma every three digits from the right
    String formattedText = '';
    for (int i = cleanText.length; i > 0; i -= 3) {
      int endIndex = i;
      int startIndex = i - 3;
      if (startIndex < 0) {
        startIndex = 0;
      }
      String segment = cleanText.substring(startIndex, endIndex);
      formattedText = segment + (formattedText.isEmpty ? '' : ',') + formattedText;
    }

    // Return the new value with comma-separated digits
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

