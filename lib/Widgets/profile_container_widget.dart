


import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class ProfileContainerWidget extends StatelessWidget {
  final String? img;
  final String? imageUrl;
  final double? height;
  final double? width;
  final String? icon;

  const ProfileContainerWidget({
    super.key,
     this.img,
    this.imageUrl,
    this.height,
    this.width, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;
    final bool showIcon = !hasNetworkImage && icon != null;
    return Container(
      height: height ?? 15.w,
      width: width ?? 15.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image:  showIcon?null: DecorationImage(
          image: hasNetworkImage
              ? NetworkImage(imageUrl!)
              : AssetImage(img!) as ImageProvider,
          fit: BoxFit.cover,
          onError: hasNetworkImage
              ? (exception, stackTrace) {

          }
              : null,
        ),
      ),
      child: showIcon? const Icon(
        Icons.person,
        color: Colors.grey,
      )
          : null,

    );
  }
}