import 'package:flutter/material.dart';

class SelectedValues {
  bool selectedAccordingValue;
  bool selectedAsValue;

  SelectedValues({required this.selectedAccordingValue, required this.selectedAsValue});
}

class SortedDialogHome extends StatefulWidget {
  final bool selectedAccordingValue;
  final bool selectedAsValue;

  const SortedDialogHome({Key? key, required this.selectedAccordingValue, required this.selectedAsValue}) : super(key: key);

  @override
  _SortedDialogHomeState createState() => _SortedDialogHomeState(SelectedValues(selectedAccordingValue: selectedAccordingValue, selectedAsValue: selectedAsValue));
}

class _SortedDialogHomeState extends State<SortedDialogHome> {
  SelectedValues selectedValues;

  _SortedDialogHomeState(this.selectedValues);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      titlePadding: EdgeInsets.all(0),
      title: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Center(child: Text('مرتب سازی لیست حساب')),
      ),
      titleTextStyle: themeData.textTheme.headline3!.copyWith(color: Colors.white, fontSize: 18),
      contentPadding: const EdgeInsets.all(8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('نام'),
              Radio(
                activeColor: Colors.deepPurple,
                value: true,
                groupValue: selectedValues.selectedAccordingValue,
                onChanged: (value) {
                  setState(() {
                    selectedValues.selectedAccordingValue = true;
                  });
                },
              ),
              Text('مبلغ'),
              Radio(
                activeColor: Colors.deepPurple,
                value: false,
                groupValue: selectedValues.selectedAccordingValue,
                onChanged: (value) {
                  setState(() {
                    selectedValues.selectedAccordingValue = false;
                  });
                },
              ),
              Directionality(textDirection: TextDirection.rtl, child: Text(' بر اساس : ')),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('صعودی'),
              Radio(
                activeColor: Colors.deepPurple,
                value: true,
                groupValue: selectedValues.selectedAsValue,
                onChanged: (value) {
                  setState(() {
                    selectedValues.selectedAsValue = true;
                  });
                },
              ),
              Text('نزولی'),
              Radio(
                activeColor: Colors.deepPurple,
                value: false,
                groupValue: selectedValues.selectedAsValue,
                onChanged: (value) {
                  setState(() {
                    selectedValues.selectedAsValue = false;
                  });
                },
              ),
              Directionality(textDirection: TextDirection.rtl, child: Text('به صورت : ')),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(selectedValues);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ثبت',
                        style: themeData.textTheme.headline3!.copyWith(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Flexible(
            //   flex: 1,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: themeData.errorColor,
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: Center(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             'لغو',
            //             style: themeData.textTheme.headline3!.copyWith(fontSize: 20, color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
