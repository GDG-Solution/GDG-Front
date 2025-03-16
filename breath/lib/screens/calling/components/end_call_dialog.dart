import 'package:flutter/material.dart';
import './dialog_button.dart';
import '../calling_end.dart';

void showEndCallDialog(BuildContext context, String counselId) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white.withAlpha(100),
        child: SizedBox(
          width: 260,
          height: 130,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "통화를 종료할까요?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DialogButton("아니요", Colors.grey[500]!, Colors.white, () {
                      Navigator.of(context).pop();
                    }),
                    SizedBox(width: 8),
                    DialogButton("통화종료", Colors.white, Colors.black, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CallingEnd(counselId: counselId)),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
