import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String imageUrl;

  const DetailImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14), // 이미지 모서리 둥글게
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 110,
        fit: BoxFit.cover, // 이미지 꽉 채우기
        errorBuilder: (context, error, stackTrace) => Container(
          width: double.infinity,
          height: 110,
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey, size: 40),
        ),
      ),
    );
  }
}
