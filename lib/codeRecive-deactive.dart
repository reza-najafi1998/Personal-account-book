import 'package:flutter/material.dart';
import 'package:payment/screens/home.dart';

class CodeRecive extends StatelessWidget {
  const CodeRecive({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
  
      //backgroundColor: const Color.fromARGB(255, 244, 244, 243),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/register.png',
                  scale: 2,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text('کد تایید برای شما پیامک شد لطفا وارد کنید',style: themeData.textTheme.headline3,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(28)),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            
                              hintText:'کد را وارد کنید',
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(),));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 227,
                    height: 50,
                    decoration: BoxDecoration(
                        color: themeData.primaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      'ورود',
                      style: themeData.textTheme.subtitle2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
