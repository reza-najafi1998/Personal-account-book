import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/codeRecive.dart';
import 'package:payment/data/data.dart';
import 'package:payment/main.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController _nameTxt = TextEditingController();
  bool iserroremptyname = false;
  final TextEditingController _passworsTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 244, 244, 243),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/register.png',
                    scale: 2,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'نام خود را وارد کنید',
                    style: themeData.textTheme.headline3,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(28)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: _nameTxt,
                                maxLength: 20,
                                enableSuggestions: false,
                                // maxLines: 1,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    hintText: 'نام خود را وارد کنید',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      )),
                  // Padding(
                  //     padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //                 color: Colors.black.withOpacity(0.1),
                  //                 blurRadius: 5)
                  //           ],
                  //           borderRadius: BorderRadius.circular(28)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  //         child: TextField(
                  //           obscureText: false,
                  //           controller: _passworsTxt,
                  //           keyboardType: TextInputType.text,
                  //           decoration: const InputDecoration(
                  //               hintText: 'کلمه عبور', border: InputBorder.none),
                  //         ),
                  //       ),
                  //     )),

                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_nameTxt.text.isNotEmpty) {
                        final user = DataUser();
                        user.name = _nameTxt.text;
                        if (user.isInBox) {
                          user.save();
                        } else {
                          final Box<DataUser> box = Hive.box('User');
                          box.add(user);
                        }
                        Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => MainScreen(),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text('لطفا نام را وارد کنید'))),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: themeData.primaryColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'ورود',
                        style: themeData.textTheme.subtitle2,
                      ),
                    ),
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async{

                      var status = await Permission.storage.status;
                      // اگر مجوز داده نشده، درخواست مجوز کنید
                      if (!status.isGranted) {
                        await Permission.storage.request();
                       // Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                      'تایید مجوز برای ذخیره فایل پشتیبانی الزامی است.'))),
                        );
                      } else {
                        try {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            String? filePath = result.files.single.path;

                            try {
                              showAlertDialog(context, 'لطفا صبر کنید');
                              // ایجاد یک شیء از کلاس File با استفاده از مسیر فایل
                              File file = File(filePath!);

                              // خواندن محتوای فایل متنی
                              List<int> fileContent = await file.readAsBytesSync();

                              String jsonString = utf8.decode(fileContent);


                              //print('first : ->'+fileContent.toString());

                              Map<String, dynamic> jsonData =
                              jsonDecode(jsonString);

                              final boxtrx =
                              Hive.box<Transactions>('Transactions');
                              final boxacc =
                                  await Hive.box<Accounts>('Accounts');
                              final boxdatauser = Hive.box<DataUser>('User');

                              List<dynamic> transactions =
                              jsonData['transactions'];
                              List<dynamic> accounts = jsonData['accounts'];
                              Map<dynamic, dynamic> user = jsonData['user'];

                              final duser = DataUser();
                              duser.name = user['name'];
                              duser.phoneNumber = '';
                              await boxdatauser.add(duser);

                              //
                              for (Map<String, dynamic> data in transactions) {
                                final trx = Transactions();
                                trx.id = data['id'];
                                trx.description = data['description'];
                                trx.price = data['price'];
                                trx.date = data['date'];
                                trx.time = data['time'];
                                trx.status = data['status'];
                                await boxtrx.add(trx);
                              }

                              for (Map<String, dynamic> data in accounts) {
                                final acc = Accounts();
                                acc.id = data['id'];
                                acc.name = data['name'];
                                await boxacc.add(acc);
                              }

                              if (boxdatauser.isNotEmpty) {
                                Navigator.pop(context);
                                //print('objectobjectobjectobjectobjectobject');
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ));
                              } else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text('error -> empty file'))),
                                );
                              }
                            } catch (e) {
                              print('خطا: $e');
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child:
                                        Text('error -> open file error'))),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text('فایلی انتخاب نشد.'))),
                            );
                          }
                        } catch (e) {
                          print('خطا: $e');
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.onTertiary,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          Icon(Icons.backup,color: Colors.white,size: 35,)
                          ,Text(
                            'فایل پشتیبان دارم',
                            style: themeData.textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
