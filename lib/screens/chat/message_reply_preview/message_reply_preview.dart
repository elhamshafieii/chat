import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/screens/chat/widgets/display_text_image_gif.dart';
import 'package:flutter/material.dart';

class MessageReplyPreview extends StatefulWidget {
  final String name;
  final MessageReply messageReply;
  final MessageEnum messageEnum;
  const MessageReplyPreview({
    Key? key,
    required this.messageReply,
    required this.messageEnum,
    required this.name,
  }) : super(key: key);

  @override
  State<MessageReplyPreview> createState() => _MessageReplyPreviewState();
}

class _MessageReplyPreviewState extends State<MessageReplyPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: LightThemeColors.tabColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                width: 5,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: messageReplyType(
                      messageType: widget.messageReply.messageEnum)),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageReplyType({required MessageEnum messageType}) {
    if (messageType == MessageEnum.text) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(child: Text(widget.name)),
            ],
          ),
          DisplayTextImageGIF(
            message: widget.messageReply.message,
            type: widget.messageReply.messageEnum,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      );
    } else if (messageType == MessageEnum.video ||
        messageType == MessageEnum.image ||
        messageType == MessageEnum.gif) {
      return Stack(children: [
        Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.messageReply.isMe ? 'You' : 'Your contact',
                      style: const TextStyle(
                        color: LightThemeColors.tabColor,
                      ),
                    ),
                    MessageReplyItem(
                      messageEnum: widget.messageEnum,
                    )
                  ],
                )),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  height: 50,
                  width: 50,
                  child: DisplayTextImageGIF(
                    message: widget.messageReply.message,
                    type: widget.messageReply.messageEnum,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ]);
    } else if (messageType == MessageEnum.audio) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(widget.messageReply.isMe ? 'Me' : 'Opposit')),
            ],
          ),
          DisplayTextImageGIF(
            message: 'Voice message',
            type: widget.messageReply.messageEnum,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      );
    } else if (messageType == MessageEnum.file) {
      return Container();
    } else {
      return Container();
    }
  }
}

class MessageReplyItem extends StatelessWidget {
  final MessageEnum messageEnum;

  const MessageReplyItem({
    super.key,
    required this.messageEnum,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getMessageReplayIcon(messageEnum),
        const SizedBox(
          width: 4,
        ),
        Text(
          messageEnum.type,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }

  Icon getMessageReplayIcon(MessageEnum messageEnum) {
    switch (messageEnum) {
      case MessageEnum.audio:
        return const Icon(
          Icons.audio_file,
          color: Colors.grey,
          size: 18,
        );

      case MessageEnum.image:
        return const Icon(
          Icons.image,
          color: Colors.grey,
          size: 18,
        );
      case MessageEnum.video:
        return const Icon(
          Icons.video_file,
          color: Colors.grey,
          size: 18,
        );
      case MessageEnum.gif:
        return const Icon(
          Icons.gif,
          color: Colors.grey,
          size: 18,
        );
      default:
        return const Icon(
          Icons.image,
          color: Colors.grey,
          size: 18,
        );
    }
  }
}
