import 'package:flutter/material.dart';

class DetailRecordMemo extends StatelessWidget {
  final String memoText; // 백엔드에서 받은 메모 내용

  const DetailRecordMemo({Key? key, required this.memoText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        memoText,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
