

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:payment/data/data.dart';
import 'package:payment/widgets/contactDialogAddPrson.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';


import 'addTransaction.dart';
import 'home.dart';

class AddPerson extends StatefulWidget {
  final String name;
  final String phone;

  const AddPerson(
      {super.key,
      required this.name,
      required this.phone});

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  bool isswitch = true;
  final TextEditingController _nameTxt = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _amountTxt = TextEditingController();
  final TextEditingController _infoTxt = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTxt.text = widget.name;
    _phone.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
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
                'فرم ثبت طرف حساب جدید',
                style: themeData.textTheme.subtitle1!.copyWith(fontSize: 23),
              ),
              const SizedBox(
                height: 16,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async{
                        Contact? cv =
                        await showDialog<Contact>(
                          context: context,
                          builder: (BuildContext context) {
                            return ContactDialogAddPerson();
                          },
                        );
                        if(cv!=null){
                          setState(() {
                            _nameTxt.text=cv.displayName;
                            _phone.text=cv.phones.first.number;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: themeData.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.contact_mail_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                    'مخاطب',
                                    style: themeData.textTheme.subtitle2!
                                        .copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                            )),
                      )),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                            onTap: () {
                              _nameTxt.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _nameTxt.text.length));
                            },
                            controller: _nameTxt,
                            maxLength: 30,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              counterText: '',
                                prefixIcon: const Icon(Icons.switch_account),
                                label: const Text('نام طرف حساب'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onTap: () {
                      _nameTxt.selection = TextSelection.fromPosition(
                          TextPosition(offset: _nameTxt.text.length));
                    },
                    controller: _phone,
                    maxLength: 12,
                    //keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.switch_account),
                        label: const Text('شماره تلفن (اختیاری)'),
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
                      if (value.isNotEmpty &&
                          value.substring(0, 1) == '0' &&
                          value.length == 1) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text('عدد صفر ابتدای مبلغ درج نخواهد شد')),
                        ));
                      }
                    },
                    controller: _amountTxt,
                    maxLength: 13,
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
                    onTap: () {
                      _infoTxt.selection = TextSelection.fromPosition(
                          TextPosition(offset: _infoTxt.text.length));
                    },
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
                onTap: () async {
                  if (_nameTxt.text.isNotEmpty && _amountTxt.text.isNotEmpty) {
                    String outputString = _amountTxt.text
                        .replaceAll(',', ''); // حذف تمام ویرگول‌ها

                    final transactions = Transactions();
                    final accounts = Accounts();
                    final box = Hive.box<Accounts>('Accounts');

                    bool isExistsname = false;
                    for (var data in box.values) {
                      if (data.name == _nameTxt.text) {
                        isExistsname = true;
                      }
                    }
                    bool isExistsphone = false;
                    for (var data in box.values) {
                      if (data.phone == _phone.text && data.phone != '') {
                        isExistsphone = true;
                      }
                    }

                    if (isExistsname) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text('نام حساب تکراری است')),
                      ));
                    } else if (isExistsphone) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text('شماره تلفن تکراری است')),
                      ));
                    } else {
                      showAlertDialog(context, 'لطفا صبر کنید');

                      var now = DateTime.now();
                      // var formatter = new intl.DateFormat('yyyy-MM-dd');
                      Gregorian g = Gregorian(now.year, now.month, now.day);

                      String temptime =
                          '${now.hour}:${now.minute}:${now.second}';
                      transactions.time = temptime;

                      //accounts.id = box.values.length + 1;
                      accounts.name = _nameTxt.text;
                      accounts.phone =
                          _phone.text.isNotEmpty ? _phone.text : '';

                      final Box<Accounts> boxacc = Hive.box('Accounts');
                      await boxacc.add(accounts);
                      accounts.id = boxacc.values
                          .toList()
                          .firstWhere(
                              (element) => element.name == _nameTxt.text)
                          .id;

                      transactions.id = accounts.id;
                      transactions.status = isswitch;
                      transactions.price = int.parse(outputString);
                      transactions.description =
                          _infoTxt.text.isNotEmpty ? _infoTxt.text : '';

                      transactions.date =
                          '${g.toJalali().year}/${g.toJalali().month}/${g.toJalali().day}';
                      transactions.time = temptime;

                      final Box<Transactions> boxtrx = Hive.box('transactions');
                      await boxtrx.add(transactions);

                        Navigator.pop(context);
                        Navigator.pop(context);

                    }
                  } else {
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
