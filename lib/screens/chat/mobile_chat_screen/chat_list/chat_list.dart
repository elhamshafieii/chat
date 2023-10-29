import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/message_reply.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/mobile_chat_screen/chat_list/bloc/chat_list_bloc.dart';
import 'package:chat/screens/chat/widgets/sender_message_card.dart';

import 'package:chat/screens/chat/widgets/message_sending_container.dart';
import 'package:chat/screens/chat/widgets/my_message_card.dart';
import 'package:chat/screens/widgets/error_screen.dart';
import 'package:chat/screens/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ChatList extends StatefulWidget {
  static ValueNotifier<MessageReply?> onMessageSwipNotifier =
      ValueNotifier(null);
  final UserModel user;
  final String contactUid;

  const ChatList({
    super.key,
    required this.contactUid,
    required this.user,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onMessageSwip(
      {required String message,
      required bool isMe,
      required MessageEnum messageEnum}) {
    ChatList.onMessageSwipNotifier.value =
        MessageReply(message, isMe, messageEnum);
  }

  saveFileToLocalStorage({required String url}) async {
    final dir = await getExternalStorageDirectory();
    final dirPath = dir!.path + '/images';
    await FlutterDownloader.enqueue(
      url: url,
      headers: {},
      savedDir: dirPath,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListBloc>(
      create: (context) {
        final chatListBloc = context.read<ChatListBloc>();
        chatListBloc.add(ChatListStarted());
        return chatListBloc;
      },
      child: BlocBuilder<ChatListBloc, ChatListState>(builder: (ontext, state) {
        if (state is ChatListError) {
          return ErrorScreen(message: state.error);
        } else if (state is ChatListLoading) {
          return const Loader();
        } else if (state is ChatListSuccess) {
          final contactUserModel = state.contactUserModel;
          return StreamBuilder(
              stream: state.messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent + 1000,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                  );
                });
                return ListView.builder(
                    controller: scrollController,
                    physics: defaultScrollPhysics,
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index < snapshot.data!.length) {
                        final messageData = snapshot.data![index];
                        var timeSent =
                            DateFormat.Hm().format(messageData.timeSent);
                        if (!messageData.isSeen &&
                            messageData.contactUid == widget.user.uid) {
                          chatRepository.setChatMessageSeen(
                              widget.contactUid, messageData.messageId);
                        }
                        //-------------------------------------
                        // if (messageData.type == MessageEnum.image) {
                        //   saveFileToLocalStorage(url: messageData.text);
                        // }
                        //-----------------------------------------
                        if (messageData.senderUid == widget.user.uid) {
                          return MyMessageCard(
                            message: messageData.text,
                            date: timeSent,
                            type: messageData.type,
                            onLeftSwipe: () {
                              onMessageSwip(
                                  message: messageData.text,
                                  isMe: true,
                                  messageEnum: messageData.type);
                            },
                            repliedText: messageData.repliedMessage,
                            username: widget.user.name,
                            repliedMessageType: messageData.repliedMessageType,
                            isSeen: messageData.isSeen,
                            replyTo: messageData.repliedTo,
                          );
                        } else {
                          return SenderMessageCard(
                            message: messageData.text,
                            date: timeSent,
                            type: messageData.type,
                            onRightSwipe: () {
                              onMessageSwip(
                                  message: messageData.text,
                                  isMe: false,
                                  messageEnum: messageData.type);
                            },
                            repliedText: messageData.repliedMessage,
                            username: contactUserModel.name,
                            repliedMessageType: messageData.repliedMessageType,
                            replyTo: messageData.repliedTo,
                          );
                        }
                      } else {
                        return MessageSendingContainer();
                      }
                    });
              });
        } else {
          throw Exception('state is not supported');
        }
      }),
    );
  }
}
