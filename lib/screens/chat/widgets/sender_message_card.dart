import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/screens/chat/widgets/display_text_image_gif.dart';
import 'package:chat/screens/chat/widgets/image_message_preview.dart';
import 'package:chat/screens/chat/widgets/reply_message_container.dart';
import 'package:chat/screens/chat/widgets/video_message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.replyTo,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final String replyTo;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    final themeData = Theme.of(context);
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 110),
          child: ChatBubble(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(19, 4, 4, 0),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            backGroundColor: LightThemeColors.senderMessageColor.shade50,
            elevation: 5,
            clipper:
                ChatBubbleClipper1(type: BubbleType.receiverBubble, radius: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isReplying) ...[
                  ReplyMessageContainer(
                    repliedMessageType: repliedMessageType,
                    type: type,
                    username: username,
                    repliedText: repliedText,
                    themeData: themeData,
                    replyTo: replyTo, isMeReply: false,
                  ),
                ],
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
                  child: DisplayTextImageGIF(
                    message: message,
                    type: type,
                  ),
                ),
                Text(
                  date,
                  style: themeData.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
