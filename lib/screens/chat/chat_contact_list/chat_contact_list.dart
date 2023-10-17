import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/chat_contact_list/bloc/chat_contact_list_bloc.dart';
import 'package:chat/screens/chat/mobile_chat_screen/chat_list/bloc/chat_list_bloc.dart';
import 'package:chat/screens/chat/mobile_chat_screen/mobile_chat_screen.dart';
import 'package:chat/screens/chat/widgets/bottom_chat_field/bloc/bottom_chat_field_bloc.dart';
import 'package:chat/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatContactsList extends StatelessWidget {
  final UserModel user;
  const ChatContactsList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider<ChatContactListBloc>(
      create: (context) {
        final bloc = ChatContactListBloc(chatRepository: chatRepository);
        bloc.add(ChatContactListStarted());

        return bloc;
      },
      child: BlocBuilder<ChatContactListBloc, ChatContactListState>(
        builder: (context, state) {
          if (state is ChatContactListSuccess) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: StreamBuilder(
                stream: state.chatContactList,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Loader());
                  }
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chatContact = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          MultiBlocProvider(providers: [
                            BlocProvider<BottomChatFieldBloc>(
                                create: (context) {
                              final bottomChatFieldBloc = BottomChatFieldBloc(
                                  authRepository: authRepository,
                                  chatRepository: chatRepository,
                                  contactUid: chatContact.contactId);
                              return bottomChatFieldBloc;
                            }),
                            BlocProvider<ChatListBloc>(create: (context) {
                              final chatListBloc = ChatListBloc(
                                  chatRepository: chatRepository,
                                  contactUid: chatContact.contactId);
                              return chatListBloc;
                            }),
                          ], child: Container());
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MobileChatScreen(
                              user: user,
                              contactUid: chatContact.contactId,
                            );
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              chatContact.name,
                              style: themeData.textTheme.bodyLarge,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                chatContact.lastMessage,
                                style: themeData.textTheme.bodySmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                            leading: chatContact.profilePic != ''
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(
                                        chatContact.profilePic),
                                    radius: 30,
                                  )
                                : const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                        'assets/images/no_profile_pic.png'),
                                    radius: 30,
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              )),
            );
          } else if (state is ChatContactListInitial) {
            return const Loader();
          } else {
            throw Exception('state is not supported');
          }
        },
      ),
    );
  }
}
