import 'dart:io';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment/screens/addPerson.dart';
import 'package:payment/services/sortedList.dart';
import 'package:permission_handler/permission_handler.dart';

List<Contact> _contacts = [];

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

class _ContactsState extends State<Contacts> {
  bool _isGranted = false;
  bool _isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchContacts();
  }

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

      if (_contacts.isEmpty) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => AddPerson(fromContactPage: true, name: '',phone: '',)),
          );
        });
        // Navigator.pushReplacement(
        //     context,
        //     CupertinoPageRoute(
        //       builder: (context) =>
        //           const AddPerson(name: '', phone: ''),
        //     ));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('هیچ مخاطبی یافت نشد')),
        ));
      } else {
        setState(() {
          _contacts.sort((a, b) => customCompare(
              a.displayName.toString(), b.displayName.toString()));
          _isloading = false;
        });
      }
      // _contacts = contacts;
    } else {
      setState(() {
        _isloading = false;
      });
      // Handle permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
            return const AddPerson(name: '', phone: '',fromContactPage: false,);
          }));
        },
        child: Container(
          width: 210,
          height: 50,
          decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'افزودن طرف حساب جدید',
                style: themeData.textTheme.subtitle2!.copyWith(fontSize: 15),
              ),
              const SizedBox(
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
      body: !_isGranted
          ? Center(
              child: Container(
                width: 350,
                height: 200,
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
                          setState(() async{
                            _fetchContacts();
                          });
                        },
                        child:  Text('درخواست مجدد مجوز',style: themeData.textTheme.subtitle2!.copyWith(fontSize: 14,fontWeight: FontWeight.w400),))
                  ],
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
              : Contactlist(),
    );
  }
}

class Contactlist extends StatefulWidget {
  @override
  State<Contactlist> createState() => _ContactlistState();
}

class _ContactlistState extends State<Contactlist> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final List<Contact> datas = _contacts
        .where((element) => element.displayName
            .toLowerCase()
            .toString()
            .contains(_controller.text.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                margin: EdgeInsets.only(top: 16),
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
                      onTap: () {
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                      },
                      onChanged: (value) {
                        setState(() {
                          //searchKeywordNotifier.value = _controller.text;
                        });
                      },
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) {
                              return AddPerson(
                                  name: datas[index].displayName,
                                  phone: datas[index].phones[0].number,
                              fromContactPage: false,);
                            },
                          ));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        datas[index].displayName,
                                        style: themeData.textTheme.subtitle1,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    datas[index].phones.isNotEmpty
                                        ? datas[index].phones[0].number
                                        : '',
                                    style: themeData.textTheme.subtitle1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(
                                'assets/images/png/user.png',
                                scale: 7,
                              ),
                              SizedBox(
                                width: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                childCount: datas.length),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 64,
            ),
          ),
        ],
      ),
    );
  }
}
