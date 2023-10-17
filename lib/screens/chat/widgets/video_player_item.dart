import 'package:blur/blur.dart';
import 'package:chat/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;


  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _videoPlayerController.initialize().then(
      (value) {
        _videoPlayerController.setVolume(1);
      },
    );
  }

  Future<double> getAspectRatio() async {
    return _videoPlayerController.value.aspectRatio;
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAspectRatio(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 45,
              child: AspectRatio(
                  aspectRatio: snapshot.data,
                  child: VideoPlayer(_videoPlayerController)),
            ),
            Blur(
              borderRadius: BorderRadius.circular(25),
              blur: 2.5,
              blurColor: Theme.of(context).primaryColor,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Icon(
              Icons.play_arrow,
              size: 40,
              color: Colors.white,
            ),
          ]);
        });
  }
}