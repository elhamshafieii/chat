import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/screens/chat/widgets/audio_player_container.dart';
import 'package:chat/screens/chat/widgets/video_player_item.dart';
import 'package:chat/screens/chat/widgets/pdf_item.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF(
      {super.key, required this.message, required this.type});

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if (widget.type == MessageEnum.text) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Text(
          widget.message,
          style: themeData.textTheme.bodyMedium,
        ),
      );
    } else if (widget.type == MessageEnum.audio) {
      return AudioPlayerContainer(message: widget.message);
    } else if (widget.type == MessageEnum.video) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: VideoPlayerItem(
            videoUrl: widget.message,
          ));
    } else if (widget.type == MessageEnum.gif) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(imageUrl: widget.message));
    } else if (widget.type == MessageEnum.image) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(imageUrl: widget.message));
    } else if (widget.type == MessageEnum.file) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: PdfItem(
            pdfUrl: widget.message,
          ));
    } else {
      return Container();
    }
  }
}
