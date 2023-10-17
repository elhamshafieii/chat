import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeWallpaperPreview extends StatefulWidget {
  static ValueNotifier<String> onChangeWallpaperNotifier =
      ValueNotifier('assets/wallpapers/default_wallpaper.jpg');
  final List<String> wallpaperAddresses;
  final int index;
  const ChangeWallpaperPreview(
      {super.key, required this.wallpaperAddresses, required this.index});

  @override
  State<ChangeWallpaperPreview> createState() => _ChangeWallpaperPreviewState();
}

class _ChangeWallpaperPreviewState extends State<ChangeWallpaperPreview> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    String wallpaperAddress = widget.wallpaperAddresses[widget.index];
    // final aaa = wallpaperAddress;
    // debugPrint('aaaaaaaaaaaaaaaa' + aaa.toString());
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Preview',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(children: [
        CarouselSlider.builder(
          carouselController: buttonCarouselController,
          itemCount: widget.wallpaperAddresses.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Image.asset(
            widget.wallpaperAddresses[itemIndex],
          ),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            aspectRatio: 1,
            viewportFraction: 1,
            initialPage: widget.index,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: false,
            enlargeFactor: 1,
            onPageChanged: (index, reason) {
              setState(() {
                wallpaperAddress = widget.wallpaperAddresses[index];
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  ChangeWallpaperPreview.onChangeWallpaperNotifier.value =
                      wallpaperAddress;
                  Fluttertoast.showToast(
                      msg: wallpaperAddress,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Text(
                    'Set Wallpaper',
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatBubble(
                  elevation: 5,
                  alignment: Alignment.centerRight,
                  clipper: ChatBubbleClipper8(
                      type: BubbleType.sendBubble, radius: 12),
                  margin: const EdgeInsets.only(top: 40),
                  backGroundColor: themeData.cardTheme.color,
                  child: const Text(
                    'Swipe left and right to preview more wallpapers',
                    maxLines: 2,
                  ),
                ),
                ChatBubble(
                  elevation: 5,
                  alignment: Alignment.centerLeft,
                  clipper: ChatBubbleClipper8(
                      type: BubbleType.receiverBubble, radius: 12),
                  margin: const EdgeInsets.only(top: 10),
                  backGroundColor: LightThemeColors.senderMessageColor.shade50,
                  child: const Text('Set wallpaper'),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
