import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';
import 'package:payment/screens/home.dart';
import 'package:payment/screens/splash.dart';
import 'package:payment/services/sortedList.dart';
import 'package:permission_handler/permission_handler.dart';

List<Contact> _contacts = [];

class ContactDialogAddPerson extends StatefulWidget {
  @override
  State<ContactDialogAddPerson> createState() => _ContactDialogAddPersonState();
}

class _ContactDialogAddPersonState extends State<ContactDialogAddPerson> {
  bool _isGranted = false;
  bool _isloading = false;

  String name = '';
  String phone = '';

  Future<void> _fetchContacts() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      setState(() {
        _isGranted = true;
      });

      final List<Contact> contacts = await FastContacts.getAllContacts();
      _contacts.clear();
      for (var data in contacts) {
        if (data.phones.isNotEmpty) {
          for (var numberphones in data.phones) {
            List<Phone> phonelist = [];
            List<Email> emaillist = [];
            StructuredName structuredName = StructuredName(
                displayName: data.displayName,
                namePrefix: '',
                givenName: '',
                middleName: '',
                familyName: '',
                nameSuffix: '');
            Organization organization = const Organization(
                company: '', department: '', jobDescription: '');

            String number = numberphones.number.replaceAll(' ', '');
            number = number.replaceAll('-', '');
            number = number.replaceAll(')', '');
            number = number.replaceAll('(', '');
            if (number.length == 13) {
              number = number.replaceAll('+98', '0');
            }
            Phone phone = Phone(number: number, label: '');
            phonelist.add(phone);

            Contact temp = Contact(
                id: data.id,
                phones: phonelist,
                emails: emaillist,
                structuredName: structuredName,
                organization: organization);
            _contacts.add(temp);
          }
          // contacts.removeAt(i);
        }
      }

      if (_contacts.isNotEmpty) {
        setState(() {
          _contacts.sort((a, b) => customCompare(
              a.displayName.toString(), b.displayName.toString()));
          _isloading = false;
        });
      }
      // _contacts = contacts;
      // Handle permission denied
    }
  }

  TextEditingController _text = TextEditingController();

  @override
  void initState() {
    _fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_contacts.length);

    final List<Contact> datas = _contacts
        .where((element) => element.displayName
            .toLowerCase()
            .toString()
            .contains(_text.text.toLowerCase()))
        .toList();

    final ThemeData themeData = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      double dialogWidth = constraints.maxWidth;
      return AlertDialog(
          backgroundColor: themeData.colorScheme.secondary,
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
            child: Center(child: Text('انتخاب مخاطب')),
          ),
          titleTextStyle: themeData.textTheme.headline3!
              .copyWith(color: Colors.white, fontSize: 18),
          contentPadding: const EdgeInsets.all(8),
          content: !_isGranted
              ? SizedBox(
                  width: dialogWidth,
                  height: 300,
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 230,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dangerous_outlined,
                            size: 55,
                            color: themeData.colorScheme.error,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              textAlign: TextAlign.center,
                              'برای انتخاب از مخاطبین تایید مجوز دسترسی به مخاطبین الزامی است.',
                              style: themeData.textTheme.subtitle1,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() async {
                                  _fetchContacts();
                                });
                              },
                              child: Text(
                                'درخواست مجدد مجوز',
                                style: themeData.textTheme.subtitle2!.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              : _isloading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'درحال دریافت مخاطبین',
                          style: themeData.textTheme.subtitle1,
                        )
                      ],
                    )
                  : SizedBox(
                      width: dialogWidth,
                      height: _contacts.isNotEmpty ? 300 : 100,
                      child: _contacts.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 16),
                                      width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color:
                                                  themeData.colorScheme.primary,
                                              width: 2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextField(
                                            onTap: () {
                                              _text.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset: _text
                                                              .text.length));
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                //searchKeywordNotifier.value = _controller.text;
                                              });
                                            },
                                            controller: _text,
                                            decoration: const InputDecoration(
                                                hintTextDirection:
                                                    TextDirection.rtl,
                                                border: InputBorder.none,
                                                hintText: 'سریع پیداش کن...',
                                                prefixIcon: Icon(
                                                  Icons.person_search,
                                                  size: 35,
                                                )

                                                // Image.asset(
                                                //   'assets/images/png/search.png',
                                                //   scale: 10,
                                                // )
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    color: themeData.colorScheme.secondary,
                                    height: 10,
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  name =
                                                      datas[index].displayName;
                                                  phone = datas[index]
                                                      .phones
                                                      .first
                                                      .number;
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Flex(
                                                  direction: Axis.horizontal,
                                                  //mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 300,
                                                            child:
                                                                Directionality(
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              child: Text(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                datas[index]
                                                                    .displayName,
                                                                style: themeData
                                                                    .textTheme
                                                                    .subtitle1,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            datas[index]
                                                                    .phones
                                                                    .isNotEmpty
                                                                ? datas[index]
                                                                    .phones[0]
                                                                    .number
                                                                : '',
                                                            style: themeData
                                                                .textTheme
                                                                .subtitle1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Image.asset(
                                                        'assets/images/png/user.png',
                                                        scale: 7,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      childCount: datas.length),
                                ),
                              ],
                            )
                          : Center(child: Text('مخاطبی پیدا نشد'))),
          actions: name.length != 0
              ? [
                  Container(
                    width: dialogWidth,
                    height: 63,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: themeData.colorScheme.secondary),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        child: Text(
                                      name,
                                      style: themeData.textTheme.subtitle1!
                                          .copyWith(fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )),
                                    Text(
                                      replaceFarsiNumber(phone),
                                      style: themeData.textTheme.subtitle1!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () {
                                List<Phone> ph = [];
                                Phone p = Phone(number: phone, label: 'label');
                                ph.add(p);

                                List<Email> em = [];
                                Email e = Email(address: '', label: '');
                                em.add(e);

                                StructuredName x = StructuredName(
                                    displayName: name,
                                    namePrefix: '',
                                    givenName: '',
                                    middleName: '',
                                    familyName: '',
                                    nameSuffix: '');

                                Organization o = Organization(
                                    company: '',
                                    department: '',
                                    jobDescription: '');

                                Contact cv = Contact(
                                    id: '0',
                                    phones: ph,
                                    emails: em,
                                    structuredName: x,
                                    organization: o);

                                Navigator.of(context).pop(cv);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: themeData
                                            .colorScheme.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'تایید',
                                        style: themeData.textTheme.subtitle2,
                                      ),
                                    )),
                              )),
                        ),
                      ],
                    ),
                  )
                ]
              : [
                  SizedBox(
                    width: dialogWidth,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: themeData.colorScheme.error,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'لغو',
                                  style: themeData.textTheme.subtitle2,
                                ),
                              )),
                        )),
                  ),
                ]);
    });
  }
}
