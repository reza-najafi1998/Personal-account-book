import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:payment/screens/addReminder.dart';
import 'package:payment/screens/addTransaction.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/widgets/settlementListTransaction.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/editPersonNameDialogHome.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({super.key, required this.id});

  final int id;

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction>
    with SingleTickerProviderStateMixin {
  bool activearchiv = false;

  bool issort = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  Future<List<List<Transactions>>> CheckTrx() {
    final List<Transactions> persontrx = [];
    for (var data in boxtrx.values.toList()) {
      if (data.id == widget.id) {
        persontrx.add(data);
        // print(data.price.toString()+'    '+data.status.toString()+'    '+data.description.toString()+'    '+data.date.toString()+'    '+data.time.toString());
      }
    }

    final List<Transactions> activeTrx = [];
    final List<Transactions> archivTrx = [];

    int sumprice = 0;
    for (int i = 0; i < persontrx.length; i++) {
      var data = persontrx[i];

      int tprice = 0;
      if (!data.status) {
        tprice = data.price * -1;
      } else {
        tprice = data.price;
      }

      if (i == 0) {
        sumprice = tprice;
        activeTrx.add(data);
      } else {
        sumprice = sumprice + tprice;
        activeTrx.add(data);
      }
      //print(data.price.toString()+'    '+data.status.toString()+'    '+data.description.toString()+'    '+data.date.toString()+'    '+data.time.toString()+'    <---->     '+sumprice.toString());
      if (sumprice == 0) {
        for (var item in activeTrx) {
          archivTrx.add(item);
        }
        activeTrx.clear();
      }
    }

    // print('------------------------active----------');
    // for(var data in activeTrx){
    //   print(data.price.toString()+'    '+data.status.toString()+'    '+data.description.toString()+'    '+data.date.toString()+'    '+data.time.toString());
    // }
    // print('------------------------archiv----------');
    // for(var data in archivTrx){
    //   print(data.price.toString()+'    '+data.status.toString()+'    '+data.description.toString()+'    '+data.date.toString()+'    '+data.time.toString());
    // }

    return Future.value([activeTrx, archivTrx]);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  ValueNotifier<List<Transactions>> activeTrx =
      ValueNotifier<List<Transactions>>([]);

  ValueNotifier<List<Transactions>> archivTrx =
      ValueNotifier<List<Transactions>>([]);

  @override
  void initState() {
    super.initState();

    CheckTrx().then((results) {
      setState(() {
        activeTrx.value = results[0];
        archivTrx.value = results[1];
      });

      // اجرای کدهای بعد از اتمام اجرای CheckTrx
      // مثلاً نمایش activeTrx و archivTrx در UI
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 90).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    CheckTrx().then((results) {
      activeTrx.value = results[0];
      archivTrx.value = results[1];
    });

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () async {
          final transactions = Transactions();
          transactions.id = widget.id;
          // print(transactions.id.toString());
          final result = await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => AddTransaction(
              trx: transactions,
            ),
          ));

          if (result == true) {
            setState(() {});
          }
        },
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'افزودن تراکنش',
                style: themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
              ),
              SizedBox(
                width: 8,
              ),
              const Icon(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      color: themeData.colorScheme.onTertiary,
                      //border: Border.all(color: themeData.colorScheme.secondary,width: 2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10)
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _makePhoneCall(
                                      hesab.getphone(widget.id),
                                    );
                                  },
                                  child: Container(
                                    //margin: const EdgeInsets.all(8),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: themeData.colorScheme.primary,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  //margin: const EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color:
                                          hesab.fullhesabperson(widget.id) >= 0
                                              ? themeData
                                                  .colorScheme.primaryContainer
                                              : themeData.colorScheme.error,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: hesab.fullhesabperson(widget.id) >= 0
                                        ? Image.asset(
                                            'assets/images/png/up.png')
                                        : Image.asset(
                                            'assets/images/png/down.png'),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          hesab.getname(widget.id),
                                          style: themeData.textTheme.subtitle1!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'تومان',
                                          style: themeData.textTheme.headline3!
                                              .copyWith(
                                                  color: Colors.white,
                                                  height: 0.4,
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 13),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          replaceFarsiNumber(hesab
                                              .fullhesabperson(widget.id)
                                              .toString()
                                              .seRagham()),
                                          style: themeData.textTheme.subtitle1!
                                              .copyWith(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Image.asset(
                                  'assets/images/png/user.png',
                                  width: 50,
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool x = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SettlementTrx(
                                    id: widget.id,
                                  );
                                },
                              );

                              if (x) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeData.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 12, 8, 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.archivebox_fill,
                                      color: Colors.black.withOpacity(0.6),
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'تسویه حساب',
                                      style: themeData.textTheme.subtitle1!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 6,
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        AddReminder(id: widget.id),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeData.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 12, 8, 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.black.withOpacity(0.6),
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'یاد آور',
                                      style: themeData.textTheme.subtitle1!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 6,
                          // ),
                          InkWell(
                            onTap: () async {
                              final boxacc = Hive.box<Accounts>('Accounts');
                              Accounts acc = boxacc.values.toList().firstWhere(
                                  (element) => element.id == widget.id);
                              bool x = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPersonNameDialogHome(
                                    accitem: acc,
                                  );
                                },
                              );

                              print(x);

                              if (x) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeData.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 12, 8, 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black.withOpacity(0.6),
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'ویرایش طرف حساب',
                                      style: themeData.textTheme.subtitle1!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: themeData.colorScheme.primary,
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: themeData.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
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
                      Row(
                        children: [
                          Text(
                            'لیست تراکنش ها',
                            style: themeData.textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.list_alt_outlined,
                            color: Colors.white,
                            size: 28,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
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
                        valueListenable: activeTrx,
                        builder: (context, value, child) {
                          return _ListBuilderAccounts(
                            issort: issort,
                            themeData: themeData,
                            trxlist: activeTrx.value,
                            refScreen: () {
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Directionality(
                    //     textDirection: TextDirection.rtl,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //           color: themeData.colorScheme.secondary),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           'برای حذف یا ویرایش تراکنش ، روی تراکنش ضربه بزنید و نگهدارید.',
                    //           style: themeData.textTheme.subtitle1!.copyWith(
                    //               fontSize: 12,
                    //               color: themeData.colorScheme.onTertiary),
                    //         ),
                    //       ),
                    //     )),
                    Visibility(
                      visible: archivTrx.value.length > 0,
                      child: InkWell(
                        onTap: () {
                          if (_controller.status == AnimationStatus.completed) {
                            activearchiv = false;
                            _controller.reverse();
                          } else {
                            activearchiv = true;
                            _controller.forward();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 340,
                            height: 40,
                            decoration: BoxDecoration(
                                color: themeData.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            width: 2)),
                                    child: Transform.rotate(
                                      angle: _animation.value * (3.14 / -180),
                                      // تبدیل درجه به رادیان
                                      child: Center(
                                          child: Icon(Icons.chevron_left,
                                              size: 20,
                                              color: Colors.black
                                                  .withOpacity(0.4))),
                                    ),
                                    // Icon(Icons.chevron_left,
                                    //     color: Colors.black.withOpacity(0.4))
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    'نمایش تراکنش های آرشیو',
                                    style: themeData.textTheme.subtitle1!
                                        .copyWith(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: activearchiv,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // decoration: BoxDecoration(
                          //   color: themeData.colorScheme.secondary.withOpacity(0.5),
                          //   borderRadius: BorderRadius.circular(20)
                          //
                          // ),
                          //height: MediaQuery.of(context).size.height,
                          child: ValueListenableBuilder(
                            valueListenable: archivTrx,
                            builder: (context, value, child) {
                              return _ListBuilderAccounts(
                                issort: issort,
                                themeData: themeData,
                                trxlist: archivTrx.value,
                                refScreen: () {
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
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
    required this.issort,
    required this.trxlist,
    required this.refScreen,
  });

  final List<Transactions> trxlist;
  final ThemeData themeData;
  final bool issort;
  final Function refScreen;

  @override
  State<_ListBuilderAccounts> createState() => _ListBuilderAccountsState();
}

class _ListBuilderAccountsState extends State<_ListBuilderAccounts> {
  @override
  Widget build(BuildContext context) {
    return widget.trxlist.isNotEmpty
        ? ListView.builder(
            reverse: widget.issort,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.trxlist.length,
            itemBuilder: (context, index) {
              // final Transactions data = widget.boxtrx.values.toList()[index];
              final Transactions data = widget.trxlist[index];
              return _ItemHesabList(
                themeData: widget.themeData,
                trxitem: data,
                edit: () {
                  widget.refScreen();
                },
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/png/empty_list.png',
                  scale: 2,
                ),
                SizedBox(
                  height: 16,
                ),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'تراکنشی یافت نشد.',
                      style: Theme.of(context).textTheme.headline3,
                    ))
              ],
            ),
          );
  }
}

class _ItemHesabList extends StatelessWidget {
  final Transactions trxitem;
  final Function edit;

  const _ItemHesabList({
    required this.themeData,
    required this.trxitem,
    required this.edit,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        final result = await editTrxDialog(context, trxitem, () {
          print(1);
          edit();
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Container(
          width: 360,
          height: trxitem.description.length > 0 ? 80 : 60,
          decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Visibility(
                visible: trxitem.description.length > 0 ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                            trxitem.description.length > 35
                                ? trxitem.description.substring(0, 35) + '...'
                                : trxitem.description,
                            style: themeData.textTheme.headline3!
                                .copyWith(color: Colors.black, fontSize: 13)),
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: trxitem.description.length > 0
                        ? const EdgeInsets.only(left: 8)
                        : const EdgeInsets.only(left: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //margin: const EdgeInsets.all(8),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: trxitem.status
                                  ? themeData.colorScheme.primaryContainer
                                  : themeData.colorScheme.error,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: trxitem.status
                                ? Image.asset('assets/images/png/up.png')
                                : Image.asset('assets/images/png/down.png'),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 35,
                              width: 130,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  replaceFarsiNumber(
                                      value.format(trxitem.price)),
                                  overflow: TextOverflow.fade,
                                  style:
                                      themeData.textTheme.headline3!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                            // Text(replaceFarsiNumber(value.format(trxitem.price)),
                            //     style: themeData.textTheme.headline3!.copyWith(
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 22,
                            //     )),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                              width: 4,
                            ),
                            Icon(
                              Icons.access_time_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(replaceFarsiNumber(trxitem.date),
                                style: themeData.textTheme.headline3!.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 10)),
                            Text(' : تاریخ',
                                style: themeData.textTheme.headline3!.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 10)),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.date_range_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
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

typedef setrefresh = void Function();

editTrxDialog(BuildContext context, Transactions trxitem, Function setrefresh) {
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
            color: themeData.colorScheme.primary,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: themeData.colorScheme.secondary,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: TextButton(
                    onPressed: () async {
                      await trxitem.delete();
                      setrefresh();
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
                          color: themeData.colorScheme.error),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'حذف',
                            style: themeData.textTheme.subtitle1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 16,
                // ),
                Flexible(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      final result =
                          await Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => AddTransaction(
                          trx: trxitem,
                        ),
                      ));

                      if (result == true) {
                        // اگر از صفحه AddTransaction برگشتیم، صفحه را رفرش کنید
                        setrefresh();
                      }

                      // await Navigator.of(context).push(CupertinoPageRoute(
                      //     builder: (context) => AddTransaction(trx: trxitem)));
                      // setrefresh();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: themeData.colorScheme.primaryContainer),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'ویرایش',
                            style: themeData.textTheme.subtitle1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
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
