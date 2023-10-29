import 'dart:io';

import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/mobile_chat_screen/chat_list/chat_list.dart';
import 'package:chat/screens/chat/widgets/bottom_chat_field/bloc/bottom_chat_field_bloc.dart';
import 'package:chat/screens/chat/message_reply_preview/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class ButtomChatField extends StatefulWidget {
  // static ValueNotifier<MessageEnum?> onMessageSendingTypeNotifier =
  //     ValueNotifier(null);
  final String contactUid;
  final UserModel currentUserModel;
  final String contactName;
  const ButtomChatField({
    super.key,
    required this.contactUid,
    required this.currentUserModel,
    required this.contactName,
  });

  @override
  State<ButtomChatField> createState() => _ButtomChatFieldState();
}

class _ButtomChatFieldState extends State<ButtomChatField> {
  bool isShowAnimatedContainer = false;
  bool isShowMessageReply = false;
  MessageReply? messageReply;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;

  @override
  void initState() {
    ChatList.onMessageSwipNotifier.addListener(onMessageSwipNotifierListener);
    super.initState();
  }

  void onMessageSwipNotifierListener() {
    setState(() {
      messageReply = ChatList.onMessageSwipNotifier.value;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmogiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() {
    focusNode.unfocus();
  }

  void openAudio() async {
    _soundRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      showSnackBar(context: context, content: 'Mic permission not allowed!');
    } else {
      await _soundRecorder!.openRecorder();
      setState(() {
        isRecorderInit = true;
      });
    }
  }

  void sendAudioMessage() async {
    openAudio();
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';
    if (!isRecorderInit) {
      return;
    }
    if (isRecording) {
      await _soundRecorder!.stopRecorder();
      // File file = File(path);
      chatRepository.sendMessage(
          message: path,
          contactUid: widget.contactUid,
          senderUserData: widget.currentUserModel,
          messageEnum: MessageEnum.audio,
          messageReply: messageReply);
    } else {
      await _soundRecorder!.startRecorder(toFile: path);
    }
    setState(() {
      isRecording = !isRecording;
      messageReply = null;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isShowMessageReply = messageReply != null;
    MessageEnum messageType = MessageEnum.text;
    return BlocProvider<BottomChatFieldBloc>(
        lazy: false,
        create: (context) {
          final bottomChatFieldBloc = context.read<BottomChatFieldBloc>();
          bottomChatFieldBloc.stream.forEach((state) {
            if (state is BottomChatFieldError) {
              showSnackBar(context: context, content: state.error);
            }
          });
          bottomChatFieldBloc.add(BottomChatFieldStarted());
          return bottomChatFieldBloc;
        },
        child: Column(
          children: [
            isShowAnimatedContainer
                ? Container(
                    padding: const EdgeInsets.all(40),
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return AnimatedContainerItem(
                                title: 'Document',
                                icon: Icons.edit_document,
                                backgroundColor: Colors.purple,
                                onTap: () async {
                                  messageType = MessageEnum.file;
                                  // File? file = await pickFile(
                                  //   context: context,
                                  //   fileType: FileType.media,
                                  // );
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );
                                  if (result != null) {
                                    File file = result.paths
                                        .map((path) => File(path!))
                                        .toList()[0];
                                    context.read<BottomChatFieldBloc>().add(
                                        BottomChatFieldSendMessageClicked(
                                            message: file.path,
                                            messageType: MessageEnum.file));
                                  }

                                  // if (file != null) {
                                  //   context.read<BottomChatFieldBloc>().add(
                                  //       BottomChatFieldSendMessageClicked(
                                  //           message: file.path,
                                  //           messageType: MessageEnum.file));
                                  // }
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );
                            case 1:
                              return AnimatedContainerItem(
                                title: 'Camera',
                                icon: Icons.camera_alt,
                                backgroundColor: Colors.pink,
                                onTap: () async {
                                  messageType = MessageEnum.image;
                                  File? image =
                                      await pickImageFromGalleryOrCamera(
                                          context, ImageSource.camera);
                                  if (image != null) {
                                    context.read<BottomChatFieldBloc>().add(
                                        BottomChatFieldSendMessageClicked(
                                            message: image.path,
                                            messageType: MessageEnum.image,
                                            messageReply: messageReply));
                                  }
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );
                            case 2:
                              return AnimatedContainerItem(
                                title: 'Gallery',
                                icon: Icons.image,
                                backgroundColor: Colors.purple.shade300,
                                onTap: () async {
                                  final File? image =
                                      await pickImageFromGalleryOrCamera(
                                          context, ImageSource.gallery);
                                  messageType = MessageEnum.image;
                                  if (image != null) {
                                    context.read<BottomChatFieldBloc>().add(
                                        BottomChatFieldSendMessageClicked(
                                            messageType: messageType,
                                            message: image.path,
                                            messageReply: messageReply));
                                    setState(() {
                                      isShowAnimatedContainer = false;
                                      messageReply = null;
                                    });
                                  }
                                },
                              );
                            case 3:
                              return AnimatedContainerItem(
                                title: 'Audio',
                                icon: Icons.headphones,
                                backgroundColor: Colors.cyan,
                                onTap: () async {
                                  final File? audio = await pickFile(
                                    context: context,
                                    fileType: FileType.audio,
                                  );
                                  messageType = MessageEnum.audio;
                                  context.read<BottomChatFieldBloc>().add(
                                      BottomChatFieldSendMessageClicked(
                                          messageType: messageType,
                                          message: audio!.path,
                                          messageReply: messageReply));
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );
                            case 4:
                              return AnimatedContainerItem(
                                title: 'Video',
                                icon: Icons.video_call,
                                backgroundColor: Colors.cyan,
                                onTap: () async {
                                  final File? video =
                                      await pickVideoFromGalleryOrCamera(
                                          context, ImageSource.gallery);
                                  messageType = MessageEnum.video;
                                  context.read<BottomChatFieldBloc>().add(
                                      BottomChatFieldSendMessageClicked(
                                          messageType: messageType,
                                          message: video!.path,
                                          messageReply: messageReply));
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );
                            case 5:
                              return AnimatedContainerItem(
                                title: 'Location',
                                icon: Icons.add_location,
                                backgroundColor: Colors.orange,
                                onTap: () async {
                                  // final File? image =
                                  //     await pickVideoFromGalleryOrCamera(
                                  //         context, ImageSource.camera);
                                  // messageType = MessageEnum.video;
                                  // context.read<BottomChatFieldBloc>().add(
                                  //     BottomChatFieldSendMessageClicked(
                                  //         messageType: messageType,
                                  //         message: image!.path,
                                  //         messageReply: messageReply));
                                  // setState(() {
                                  //   isShowAnimatedContainer = false;
                                  //   messageReply = null;
                                  // });
                                },
                              );
                            case 6:
                              return AnimatedContainerItem(
                                title: 'Contact',
                                icon: Icons.person,
                                backgroundColor: Colors.green,
                                onTap: () async {
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );
                            case 7:
                              return AnimatedContainerItem(
                                title: 'Poll',
                                icon: Icons.poll,
                                backgroundColor: Colors.blue,
                                onTap: () {
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                    messageReply = null;
                                  });
                                },
                              );

                            default:
                          }
                          return null;
                        }),
                  )
                : Container(),
            const SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: isShowMessageReply
                            ? BorderRadius.circular(12)
                            : BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 0.5)
                        ]),
                    child: Column(
                      children: [
                        isShowMessageReply
                            ? Stack(children: [
                                MessageReplyPreview(
                                  messageReply: messageReply!,
                                  messageEnum: messageReply!.messageEnum,
                                  name: messageReply!.isMe
                                      ? widget.currentUserModel.name
                                      : widget.contactName,
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey,
                                          )),
                                      child: const Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isShowMessageReply = false;
                                        messageReply = null;
                                      });
                                    },
                                  ),
                                ),
                              ])
                            : const SizedBox(),
                        Container(
                          padding: EdgeInsets.only(left: 8),
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: _messageController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  isShowSendButton = true;
                                });
                              } else {
                                setState(() {
                                  isShowSendButton = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: 'Type a message!',
                              filled: true,
                              prefixIcon: SizedBox(
                                width: 10,
                                child: Row(children: [
                                  InkWell(
                                    onTap: toggleEmogiKeyboardContainer,
                                    child: Icon(
                                      isShowEmojiContainer
                                          ? Icons.keyboard
                                          : Icons.emoji_emotions_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]),
                              ),
                              suffixIcon: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isShowAnimatedContainer =
                                              !isShowAnimatedContainer;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.attach_file,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        File? image =
                                            await pickImageFromGalleryOrCamera(
                                                context, ImageSource.camera);
                                        if (image != null) {
                                          context.read<BottomChatFieldBloc>().add(
                                              BottomChatFieldSendMessageClicked(
                                                  message: image.path,
                                                  messageType:
                                                      MessageEnum.image,
                                                  messageReply: messageReply));
                                        }
                                        setState(() {
                                          messageReply = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isShowSendButton) {
                      if (_messageController.text.isNotEmpty) {
                        context.read<BottomChatFieldBloc>().add(
                            BottomChatFieldSendMessageClicked(
                                message: _messageController.text,
                                messageType: MessageEnum.text,
                                messageReply: messageReply));
                        setState(() {
                          messageReply = null;
                          _messageController.text = '';
                        });
                      }
                    } else {
                      sendAudioMessage();
                    }
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xff128c7e),
                    child: buttomChatFieldSendMicIcon(),
                  ),
                ),
                const SizedBox(
                  width: 4,
                )
              ],
            ),
            isShowEmojiContainer
                ? SizedBox(
                    height: 310,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        setState(() {
                          _messageController.text =
                              _messageController.text + emoji.emoji;
                        });
                        if (!isShowSendButton) {
                          setState(() {
                            isShowSendButton = true;
                          });
                        }
                      },
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }

  Icon buttomChatFieldSendMicIcon() {
    if (isShowSendButton) {
      return const Icon(
        Icons.send,
        color: Colors.white,
      );
    } else {
      if (isRecording) {
        return const Icon(
          Icons.close,
          color: Colors.white,
        );
      } else {
        return const Icon(
          Icons.mic,
          color: Colors.white,
        );
      }
    }
  }
}

class AnimatedContainerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const AnimatedContainerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: backgroundColor,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }
}
