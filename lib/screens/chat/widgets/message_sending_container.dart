import 'dart:io';
import 'dart:math';

import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/screens/chat/widgets/video_player_item.dart';
import 'package:chat/screens/chat/widgets/bottom_chat_field/bloc/bottom_chat_field_bloc.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:path/path.dart' as p;
import 'package:tinycolor2/tinycolor2.dart';

class MessageSendingContainer extends StatefulWidget {
  const MessageSendingContainer({
    super.key,
  });

  @override
  State<MessageSendingContainer> createState() =>
      _MessageSendingContainerState();
}

class _MessageSendingContainerState extends State<MessageSendingContainer> {
  String? message;
  MessageEnum? messageType;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomChatFieldBloc, BottomChatFieldState>(
        listener: (context, state) {
          if (state is BottomChatFieldLoading) {
            setState(() {
              message = state.message;
              messageType = state.messageType;
            });
          } else if (state is BottomChatFieldSuccess) {
            setState(() {
              message = null;
              messageType = null;
            });
          }
        },
        child: message != null
            ? MessageSendingContainerItem(
                message: message!,
                messageType: messageType!,
              )
            : Container());
  }
}

class MessageSendingContainerItem extends StatelessWidget {
  final String message;
  final MessageEnum messageType;
  const MessageSendingContainerItem({
    super.key,
    required this.message,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 0,
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: 0),
        child: ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 4, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          backGroundColor: Theme.of(context).cardTheme.color,
          elevation: 2,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: getMessageSendingContainerItem(
              message: message, messageType: messageType, context: context),
        ),
      ),
    );
  }

  Widget getMessageSendingContainerItem(
      {required String message,
      required MessageEnum messageType,
      required BuildContext context}) {
    switch (messageType) {
      case MessageEnum.image:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(message))),
            ),
            SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ))
          ],
        );
      case MessageEnum.video:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoPlayerItem(
                    videoUrl: message,
                  )),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ]),
            )
          ],
        );
      case MessageEnum.gif:
        return Stack();
      case MessageEnum.text:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              width: 4,
            ),
            CupertinoActivityIndicator(
              radius: 10,
            )
          ],
        );
      case MessageEnum.audio:
        return Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: Icon(
                Icons.headphones,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    width: 23,
                    height: 23,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ))
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: SliderTheme(
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
                value: 0,
                onChanged: (double value) async {},
              ),
            )),
          ],
        );
      case MessageEnum.file:
        return FutureBuilder<String>(
            future: getFirstPageDocument(message),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              File file = File(message);
              return Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 45,
                        height: 200,
                        child: FittedBox(
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                            child: Image.file(File(snapshot.data!))))),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color!.shade(7)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_present_outlined,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.basename(file.path),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              getfilesizestring(bytes: file.lengthSync()) +
                                  ' . PDF',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]);
            }));
      default:
        return Container();
    }
  }
}

Future<String> getFirstPageDocument(String path) async {
  File file = File(path);
  PDFDocument document = await PDFDocument.fromFile(file);
  PDFPage pageOne = await document.get(page: 1);
  final pageImage = await pageOne.imgPath;
  return pageImage!;
}

String getfilesizestring({required int bytes}) {
  const suffixes = [" bytes", "kb", "mb", "gb", "tb"];
  var i = (log(bytes) / log(1024)).floor();
  return (bytes / pow(1024, i)).round().toString() + suffixes[i];
}
