// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ImageSliderScreen extends StatefulWidget {
  final List<String> images;

  const ImageSliderScreen({super.key, required this.images});

  @override
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.images[index],
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            top: 30.0,
            left: 28.0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
