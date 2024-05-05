import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/screens/addReminder.dart';
import 'package:payment/screens/addTransaction.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({super.key, required this.id});

  final int id;

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  bool issort = true;

  @override
  Widget build(BuildContext context) {
    // final boxtrx = Hive.box<Transactions>('Transactions');
    // final boxacc = Hive.box<Accounts>('Accounts');
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          final transactions = Transactions();
          transactions.id = widget.id;
          // print(transactions.id.toString());
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => AddTransaction(
                    trx: transactions,
                  )));
        },
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'افزودن تراکنش',
                style:
                themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
              ),                SizedBox(width: 8,)
              ,const Icon(
                CupertinoIcons.plus_circle,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: themeData.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: themeData.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                          child: Row(
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: DropdownButton<String>(
                                  isDense: true,
                                  hint: Text(
                                    'مرتب سازی',
                                    style: themeData.textTheme.subtitle1!
                                        .copyWith(fontSize: 12),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down),
                                  style: themeData.textTheme.subtitle1!
                                      .copyWith(fontSize: 10),
                                  items: <String>['نزولی', 'صعودی']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(value)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == 'نزولی') {
                                        issort = false;
                                      } else if (value == 'صعودی') {
                                        issort = true;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'لیست تراکنش ها',
                    style: themeData.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AddReminder(id: widget.id),
                      ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurpleAccent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.alarm,
                        color: Colors.white,
                        size: 45,
                      ),
                      Text(
                        'ثبت یادآور',
                        style: themeData.textTheme.headline3!.copyWith(
                            color: Colors.white, fontSize: 25),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      child: ValueListenableBuilder(
                        valueListenable: boxtrx.listenable(),
                        builder: (context, value, child) {
                          return _ListBuilderAccounts(
                              issort: issort,
                              id: widget.id,
                              boxtrx: boxtrx,
                              boxacc: boxacc,
                              themeData: themeData);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class _ListBuilderAccounts extends StatefulWidget {
  const _ListBuilderAccounts({
    super.key,
    required this.themeData,
    required this.boxtrx,
    required this.boxacc,
    required this.id,
    required this.issort,
  });

  final Box<Transactions> boxtrx;
  final Box<Accounts> boxacc;
  final ThemeData themeData;
  final int id;
  final bool issort;

  @override
  State<_ListBuilderAccounts> createState() => _ListBuilderAccountsState();
}

class _ListBuilderAccountsState extends State<_ListBuilderAccounts> {
  @override
  Widget build(BuildContext context) {
    // final Transactions datax = widget.boxtrx.values.toList()[5];
    //
    // print(' trx -> '+datax.time.toString());
    final List<Transactions> persontrx = [];
    for (var data in widget.boxtrx.values.toList()) {
      if (data.id == widget.id) {
        persontrx.add(data);
      }
    }
    return persontrx.isNotEmpty? ListView.builder(
      reverse: widget.issort,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: persontrx.length,
      itemBuilder: (context, index) {
        // final Transactions data = widget.boxtrx.values.toList()[index];
        final Transactions data = persontrx[index];
        return  _ItemHesabList(
                themeData: widget.themeData,
                trxitem: data,
              );
      },
    ): Padding(
    padding: const EdgeInsets.only(top: 64),
    child: Column(

      children: [
        Image.asset(
        'assets/images/png/empty_list.png',
        scale: 2,
        ),SizedBox(height: 16,)
        ,
        Directionality(
            textDirection: TextDirection.rtl,
            child: Text('تراکنشی یافت نشد.',style: Theme.of(context).textTheme.headline3,))
      ],
    ),
    );
  }
}

class _ItemHesabList extends StatelessWidget {
  final Transactions trxitem;

  const _ItemHesabList({
    required this.themeData,
    required this.trxitem,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showAlertDialog(context, trxitem);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Container(
          width: 360,
          height: 70,
          decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: trxitem.status
                            ? const Color.fromARGB(255, 4, 246, 28)
                            : const Color.fromARGB(255, 246, 28, 4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: trxitem.status
                          ? Image.asset('assets/images/png/up.png')
                          : Image.asset('assets/images/png/down.png'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(replaceFarsiNumber(value.format(trxitem.price)),
                          style: themeData.textTheme.headline3!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                      Text(
                        'تومان',
                        style: themeData.textTheme.headline3!.copyWith(
                            color: Colors.black,
                            height: 0.4,
                            fontWeight: FontWeight.w100,
                            fontSize: 13),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                                trxitem.description.length > 20
                                    ? trxitem.description.substring(0, 18) +
                                        '...'
                                    : trxitem.description,
                                style: themeData.textTheme.headline3!.copyWith(
                                    color: Colors.black, fontSize: 13)),
                          ),
                          Text(': توضیحات',
                              style: themeData.textTheme.headline3!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          Icon(
                            CupertinoIcons.doc_text,
                            size: 18,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(replaceFarsiNumber(trxitem.time),
                              style: themeData.textTheme.headline3!.copyWith(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10)),
                          Text(' : ساعت',
                              style: themeData.textTheme.headline3!.copyWith(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10)),
                          SizedBox(
                            width: 5,
                          ),
                          Text(replaceFarsiNumber(trxitem.date),
                              style: themeData.textTheme.headline3!.copyWith(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10)),
                          Text(' : تاریخ',
                              style: themeData.textTheme.headline3!.copyWith(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10)),
                          Icon(
                            Icons.date_range_outlined,
                            size: 18,
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }

  return input;
}

showAlertDialog(BuildContext context, Transactions trxitem) {
  // set up the button
  // Widget okButton = TextButton(
  //   child: Text("OK"),
  //   onPressed: () {},
  // );
  final ThemeData themeData = Theme.of(context);
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    titlePadding: EdgeInsets.all(0),
    title: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Center(child: Text('ویرایش تراکنش'))),
    //actionsAlignment: MainAxisAlignment.start,
    titleTextStyle: themeData.textTheme.headline3!
        .copyWith(color: Colors.white, fontSize: 18),
    contentPadding: const EdgeInsets.all(8),

    // title: Text("My title"),
    content: SizedBox(
      // width: 150,
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: themeData.colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text('توضیحات : ')),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        '  ' + trxitem.description,
                        style: TextStyle(fontSize: 13),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      await trxitem.delete();

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text('تراکنش با موفقیت حذف شد')),
                      ));
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'حذف',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => AddTransaction(trx: trxitem)));
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'ویرایش',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
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
