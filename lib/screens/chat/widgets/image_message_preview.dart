import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:flutter/material.dart';

class ImageMessagePreview extends StatelessWidget {
  final String message;
  final String dateTime;
  final String userName;

  const ImageMessagePreview({
    super.key,
    required this.message,
    required this.dateTime,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: DarkThemeColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: DarkThemeColors.backgroundColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(color: Colors.white),
              ),
              Text(
                dateTime,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.star_border_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.forward)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Center(child: CachedNetworkImage(imageUrl: message)));
  }
}
