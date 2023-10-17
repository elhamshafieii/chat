

import 'package:chat/common/utils/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessagePreview extends StatefulWidget {
  final String message;
  final String dateTime;
  final String userName;

  const VideoMessagePreview({
    super.key,
    required this.message,
    required this.dateTime,
    required this.userName,
  });

  @override
  State<VideoMessagePreview> createState() => _VideoMessagePreviewState();
}

class _VideoMessagePreviewState extends State<VideoMessagePreview> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isPlaying = false;

  @override
  void initState() {
    
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.message))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    _chewieController = ChewieController(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        videoPlayerController: _videoPlayerController,
        materialProgressColors: ChewieProgressColors(
          backgroundColor: Colors.white,
          playedColor: LightThemeColors.tabColor,
          handleColor: LightThemeColors.tabColor,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

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
                widget.userName,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(color: Colors.white),
              ),
              Text(
                widget.dateTime,
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
        body: _videoPlayerController.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _chewieController.aspectRatio!.toDouble(),
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              )
            : Container());
  }
}
