import 'package:flutter/material.dart';
import '../utils/covert.dart';
import '../utils/fonts.dart';

class ValidationDialog {
  static void show(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValidationDialogWidget(title: title, content: content);
      },
    );
  }
}

class ValidationDialogWidget extends StatelessWidget {
  final String title;
  final String content;

  const ValidationDialogWidget({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: darkBoldFont),
            SizedBox(height: 10),
            Text(content, style: normalFont),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(
                "OK",
                style: boldFont,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hexStringToColor("#44564a"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
