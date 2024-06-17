import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoachmarkDesc extends StatefulWidget {
  final String text;
  final String skip;
  final String next;
  final void Function() onSkip;
  final void Function() onNext;

  const CoachmarkDesc(
      {
      required this.text,
      this.skip = "بلدم",
      this.next = "برو بعدی",

      required this.onSkip,
      required this.onNext,
});

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                widget.text,
                style: themeData.textTheme.subtitle1!.copyWith(fontSize: 15),
              )),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: widget.onSkip,
                  child: Text(widget.skip,
                      style: themeData.textTheme.subtitle1!
                          .copyWith(fontSize: 15))),
              SizedBox(
                width: 16,
              ),
              SizedBox(width: 8,),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          themeData.colorScheme.primaryContainer),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      )),
                  onPressed: widget.onNext,
                  child: Text(widget.next,
                      style: themeData.textTheme.subtitle2!
                          .copyWith(fontSize: 15))),

            ],
          )
        ],
      ),
    );
  }
}
