import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/screens/chat/widgets/display_text_image_gif.dart';
import 'package:chat/screens/chat/message_reply_preview/message_reply_preview.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ReplyMessageContainer extends StatelessWidget {
  const ReplyMessageContainer({
    super.key,
    required this.repliedMessageType,
    required this.type,
    required this.username,
    required this.repliedText,
    required this.themeData,
  });

  final MessageEnum repliedMessageType;
  final MessageEnum type;
  final String username;
  final String repliedText;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    if ((type == MessageEnum.text || type == MessageEnum.audio) &&
        (repliedMessageType == MessageEnum.text ||
            repliedMessageType == MessageEnum.audio)) {
      return Container(
          constraints: const BoxConstraints(
            maxHeight: double.infinity,
          ),
          height: 60,
          decoration: BoxDecoration(
            color: themeData.cardTheme.color!.shade(7),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 60,
                decoration: const BoxDecoration(
                  color: DarkThemeColors.selectedLableColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: DarkThemeColors.selectedLableColor,
                      ),
                    ),
                    repliedMessageType == MessageEnum.text
                        ? Text(
                            repliedText,
                            style: themeData.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        : MessageReplyItem(
                            messageEnum: repliedMessageType,
                          ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ));
    } else if ((type == MessageEnum.video ||
                type == MessageEnum.image ||
                type == MessageEnum.gif) &&
            repliedMessageType == MessageEnum.text ||
        repliedMessageType == MessageEnum.audio) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: themeData.cardTheme.color!.shade(7),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 5,
              height: 60,
              decoration: const BoxDecoration(
                color: DarkThemeColors.selectedLableColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: DarkThemeColors.selectedLableColor,
                  ),
                ),
                repliedMessageType == MessageEnum.text
                    ? Text(
                        repliedText,
                        style: themeData.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    : MessageReplyItem(
                        messageEnum: repliedMessageType,
                      ),
              ],
            ),
          ],
        ),
      );
    } else if ((type == MessageEnum.text || type == MessageEnum.audio) &&
        (repliedMessageType == MessageEnum.video ||
            repliedMessageType == MessageEnum.image ||
            repliedMessageType == MessageEnum.gif)) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: themeData.cardTheme.color!.shade(7),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 60,
              decoration: const BoxDecoration(
                color: DarkThemeColors.selectedLableColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: DarkThemeColors.selectedLableColor,
                    ),
                  ),
                  MessageReplyItem(
                    messageEnum: repliedMessageType,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: DisplayTextImageGIF(
                  message: repliedText,
                  type: repliedMessageType,
                ),
              ),
            ),
          ],
        ),
      );
    } else if ((type == MessageEnum.video ||
            type == MessageEnum.image ||
            type == MessageEnum.gif) &&
        (repliedMessageType == MessageEnum.video ||
            repliedMessageType == MessageEnum.image ||
            repliedMessageType == MessageEnum.gif)) {
      return Container(
        width: MediaQuery.of(context).size.width - 45,
        height: 60,
        decoration: BoxDecoration(
          color: themeData.cardTheme.color!.shade(7),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 5,
              height: 60,
              decoration: const BoxDecoration(
                color: DarkThemeColors.selectedLableColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: DarkThemeColors.selectedLableColor,
                    ),
                  ),
                  MessageReplyItem(
                    messageEnum: repliedMessageType,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: DisplayTextImageGIF(
                  message: repliedText,
                  type: repliedMessageType,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(width: 100, height: 40, color: Colors.red);
    }
  }
}
