import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String imageUrl;

  const DetailImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNetwork = imageUrl.startsWith("http");

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: isNetwork
          ? Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    color: Colors.grey, size: 40),
              ),
            )
          : Image.asset(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
    );
  }
}
