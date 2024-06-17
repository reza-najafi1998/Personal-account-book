import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../calculatorHesab.dart';
import '../data/data.dart';
import 'home.dart';
import 'listTransaction.dart';

TextEditingController _controller = TextEditingController();

class RemoveAccounts extends StatefulWidget {
  @override
  State<RemoveAccounts> createState() => _RemoveAccountsState();
}

class _RemoveAccountsState extends State<RemoveAccounts> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: themeData.colorScheme.primary, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchKeywordNotifier.value = _controller.text;
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        border: InputBorder.none,
                        hintText: 'سریع پیداش کن...',
                        prefixIcon: Icon(
                          Icons.person_search,
                          size: 35,
                        )),
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: boxacc.listenable(),
            builder: (context, value, child) {
              return boxacc.values.isNotEmpty
                  ? _ListBuilderAccounts(
                      boxtrx: boxtrx,
                      boxacc: boxacc,
                      themeData: themeData,
                      hesab: hesab,
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
                                'حسابی یافت نشد.',
                                style: Theme.of(context).textTheme.headline3,
                              ))
                        ],
                      ),
                    );
            },
          ),
        ],
      )),
    );
  }
}

class _ListBuilderAccounts extends StatelessWidget {
  const _ListBuilderAccounts({
    super.key,
    required this.themeData,
    required this.boxtrx,
    required this.boxacc,
    required this.hesab,
  });

  final Box<Transactions> boxtrx;
  final Box<Accounts> boxacc;
  final ThemeData themeData;
  final CalculatorHesab hesab;

  @override
  Widget build(BuildContext context) {
    final List<Accounts> datas = boxacc.values
        .where((element) => element.name.contains(_controller.text))
        .toList();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      itemCount: datas.length,
      itemBuilder: (context, index) {
        final Accounts data = datas[index];
        int tempprice = hesab.fullhesabperson(data.id);

        return _ItemHesabList(
          themeData: themeData,
          id: data.id,
          name: data.name,
          price: tempprice.toString(),
          state: tempprice >= 0 ? true : false,
          date: hesab.lastdatetrx(data.id),
          accitem: data,
        );
      },
    );
  }
}

class _ItemHesabList extends StatefulWidget {
  final int id;
  final String name;
  final String price;
  final bool state;
  final String date;
  final ThemeData themeData;
  final Accounts accitem;

  const _ItemHesabList({
    required this.themeData,
    required this.name,
    required this.price,
    required this.state,
    required this.id,
    required this.date,
    required this.accitem,
  });

  @override
  State<_ItemHesabList> createState() => _ItemHesabListState();
}

class _ItemHesabListState extends State<_ItemHesabList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Container(
        width: 360,
        height: 70,
        decoration: BoxDecoration(
          color: widget.themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    deleteaccount(
                        context, widget.themeData, widget.accitem, widget.name);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    width: 50,
                    height: 70,
                    decoration: BoxDecoration(
                        color: widget.themeData.colorScheme.error,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.delete_solid,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            'حذف',
                            style: widget.themeData.textTheme.headline3!
                                .copyWith(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: widget.state
                          ? widget.themeData.colorScheme.primaryContainer
                              .withOpacity(0.3)
                          : widget.themeData.colorScheme.error.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: widget.state
                        ? Image.asset(
                            'assets/images/png/up.png',
                            scale: 3,
                          )
                        : Image.asset(
                            'assets/images/png/down.png',
                            scale: 3,
                          ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 35,
                      width: 80,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          replaceFarsiNumber(
                              value.format(int.parse(widget.price))),
                          overflow: TextOverflow.fade,
                          style: widget.themeData.textTheme.headline3!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'تومان',
                      style: widget.themeData.textTheme.headline3!.copyWith(
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
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 140,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(widget.name,
                            overflow: TextOverflow.ellipsis,
                            style: widget.themeData.textTheme.headline3!
                                .copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Row(
                      children: [
                        Text(replaceFarsiNumber(hesab.lastdatetrx(widget.id)),
                            style:
                                widget.themeData.textTheme.headline3!.copyWith(
                              color: Colors.black,
                              fontSize: 13,
                            )),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('آخرین تراکنش : ',
                              style: widget.themeData.textTheme.headline3!
                                  .copyWith(
                                color: Colors.black,
                                fontSize: 13,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  'assets/images/png/user.png',
                  width: 45,
                ),
                const SizedBox(
                  width: 6,
                )
              ],
            )
          ],
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

deleteaccount(
    BuildContext context, ThemeData themeData, Accounts accitem, String name) {
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
