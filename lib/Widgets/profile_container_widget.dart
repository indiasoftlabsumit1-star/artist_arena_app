


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class ProfileContainerWidget extends StatelessWidget {
  final String img;
  final String? imageUrl;
  final double? height;
  final double? width;

  const ProfileContainerWidget({
    super.key,
    required this.img,
    this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      height: height ?? 15.w,
      width: width ?? 15.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: hasNetworkImage
              ? NetworkImage(imageUrl!)
              : AssetImage(img) as ImageProvider,
          fit: BoxFit.cover,
          onError: hasNetworkImage
              ? (exception, stackTrace) {}
              : null,
        ),
      ),
    );
  }
}