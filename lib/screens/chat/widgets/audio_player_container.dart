import 'package:chat/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerContainer extends StatefulWidget {
  final String message;
  const AudioPlayerContainer({super.key, required this.message});

  @override
  State<AudioPlayerContainer> createState() => _AudioPlayerContainerState();
}

class _AudioPlayerContainerState extends State<AudioPlayerContainer> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isCompleted = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future initAudoPlayer() async {
    try {
      duration = (await audioPlayer.setUrl(widget.message))!;
    } on PlayerException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  void initState() {
    initAudoPlayer();
    audioPlayer.playerStateStream.listen((event) async {
      isPlaying = event.playing;
      // setState(() {
      //   isPlaying = event.playing;
      // });
      if (event.processingState == ProcessingState.completed) {
        isPlaying = false;
        position = const Duration(seconds: 0);
        isCompleted = true;
        // setState(() {
        //   isPlaying = false;
        //   position = const Duration(seconds: 0);
        //   isCompleted = true;
        // });
      }
    });
    audioPlayer.durationStream.listen((newDuration) {
      duration = newDuration!;
      // setState(() {
      //   duration = newDuration!;
      // });
    });
    audioPlayer.positionStream.listen((newPosition) {
      position = newPosition;
      // setState(() {
      //   position = newPosition;
      // });
    });
    super.initState();
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 45,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: Icon(
            Icons.headphones,
            color: Colors.white,
          ),
        ),
        GestureDetector(
            onTap: () async {
              if (isPlaying) {
                setState(() {
                  isPlaying = false;
                });
                await audioPlayer.pause();
              } else {
                setState(() {
                  isPlaying = true;
                  isCompleted = false;
                });
                await audioPlayer.play();
                if (isCompleted) {
                  await audioPlayer.seek(const Duration(seconds: 0));
                  await audioPlayer.pause();
                }
              }
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 30,
              color: Colors.black.withOpacity(0.6),
            )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: Column(
          children: [
            SizedBox(
              height: 17,
            ),
            SliderTheme(
              data: SliderThemeData(
                overlayShape: SliderComponentShape.noOverlay,
                overlayColor: Colors.red,
                trackHeight: 2,
                thumbColor: Colors.black.withOpacity(0.6),
                activeTrackColor: Colors.black.withOpacity(0.6),
                inactiveTrackColor: Colors.black.withOpacity(0.3),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (double value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                },
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(position.inSeconds),
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.6)),
                ),
                Text(
                  formatDuration(duration.inSeconds),
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ))
      ]),
    );
  }
}
