import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment/main.dart';
import 'package:payment/screens/register.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemOnbording {
  final String title;
  final String description;
  final String image;

  ItemOnbording(this.title, this.description, this.image);
}

ItemOnbording a1 = ItemOnbording(
    'دفتر حساب',
    'خودتون رو بی نیاز کنید از یادداشت نویسی برای حساب های مالی شخصیتون با اپلیکیشن دفتر حساب',
    'logo.png');
ItemOnbording a2 = ItemOnbording(
    'نامحدود حساب بسازید',
    'با خیال راحت به تعداد نامحدود حساب برای افراد مختلف ایجاد کنید و حسابشون رو ثبت کنید',
    'listcontact_vector.png');
ItemOnbording a3 = ItemOnbording(
    'هیچ وقت فراموش نمی کنید',
    'با سرویس یادآور برای هر زمانی که دوست دارید هشدار تنظیم کنید تا به شما یادآوری کند',
    'notify_vector.png');
ItemOnbording a4 = ItemOnbording(
    'امنیت اطلاعات',
    'با پشتیبان گیری آفلاین از اطلاعاتون محافظت کنید و هنگام تغییر گوشی به گوشی جدید منتقل کنید.',
    'backup_vector.png');

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  // final items = AppDatabase.onBoardingItems;
  int page = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      if (_pageController.page!.round() != page) {
        setState(() {
          page = _pageController.page!.round();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late List<ItemOnbording> items = [];
    items.add(a1);
    items.add(a2);
    items.add(a3);
    items.add(a4);

    final ThemeData themedata = Theme.of(context);
    return Scaffold(
      backgroundColor: themedata.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 8),
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 200,
                              height: 200,
                              child:
                                  Image.asset('assets/images/png/onboarding/'+items[index].image)),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  items[index].title,
                                  style: themedata.textTheme.subtitle1!
                                      .copyWith(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      items[index].description,
                                      style: themedata.textTheme.headline3,
                                    ))
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff5282FF).withOpacity(0.07),
                        blurRadius: 32)
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  color: themedata.colorScheme.surface),
              child: Column(
                children: [
                  // Expanded(
                  //     child: PageView.builder(
                  //         controller: _pageController,
                  //         itemCount: items.length,
                  //         itemBuilder: (context, index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.all(30),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   items[index].title,
                  //                   style: themedata.textTheme.subtitle1!
                  //                       .copyWith(fontSize: 22),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 16,
                  //                 ),
                  //                 Directionality(
                  //                     textDirection: TextDirection.rtl,
                  //                     child: Text(
                  //                       items[index].description,
                  //                       style: themedata.textTheme.headline3,
                  //                     ))
                  //               ],
                  //             ),
                  //           );
                  //         })),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: items.length,
                          effect: ExpandingDotsEffect(
                              activeDotColor: themedata.colorScheme.primary,
                              dotColor: themedata.colorScheme.primary
                                  .withOpacity(0.1),
                              dotWidth: 8,
                              dotHeight: 8),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(84, 60)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)))),
                            onPressed: () {
                              if (page == items.length - 1) {
                                Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                        builder: (context) => Register()));
                              } else {
                                _pageController.animateToPage(page + 1,
                                    duration: Duration(microseconds: 600000),
                                    curve: Curves.decelerate);
                              }
                            },
                            child: Icon(page == items.length - 1
                                ? CupertinoIcons.check_mark
                                : CupertinoIcons.arrow_right))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
