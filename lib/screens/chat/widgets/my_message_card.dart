import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/screens/chat/widgets/display_text_image_gif.dart';
import 'package:chat/screens/chat/widgets/image_message_preview.dart';
import 'package:chat/screens/chat/widgets/video_message_preview.dart';
import 'package:chat/screens/chat/widgets/reply_message_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final String replyTo;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
    required this.replyTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 0,
              maxWidth: MediaQuery.of(context).size.width - 45,
              minWidth: 0),
          child: ChatBubble(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(5, 4, 19, 0),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            backGroundColor: themeData.cardTheme.color,
            elevation: 2,
            clipper:
                ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isReplying) ...[
                    ReplyMessageContainer(
                      repliedMessageType: repliedMessageType,
                      type: type,
                      username: username,
                      repliedText: repliedText,
                      themeData: themeData,
                      replyTo: replyTo,
                      isMeReply: true,
                    ),
                  ],
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      if (type == MessageEnum.image) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ImageMessagePreview(
                            message: message,
                            dateTime: date,
                            userName: username,
                          );
                        }));
                      } else if (type == MessageEnum.video) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VideoMessagePreview(
                            message: message,
                            dateTime: date,
                            userName: username,
                          );
                        }));
                      }
                    },
                    onLongPress: () {},
                    child: Stack(alignment: Alignment.center, children: [
                      DisplayTextImageGIF(
                        message: message,
                        type: type,
                      ),
                    ]),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: themeData.textTheme.labelSmall!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 18,
                        color: isSeen ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
