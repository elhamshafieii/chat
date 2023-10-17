import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/enums/message_enum.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/data/repository/chat_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/contact_detail/contact_detail_screen.dart';
import 'package:chat/screens/chat/mobile_chat_screen/chat_list/bloc/chat_list_bloc.dart';
import 'package:chat/screens/chat/widgets/bottom_chat_field/bloc/bottom_chat_field_bloc.dart';
import 'package:chat/screens/chat/widgets/bottom_chat_field/bottom_chat_field.dart';
import 'package:chat/screens/chat/mobile_chat_screen/bloc/mobile_chat_ecreen_bloc.dart';
import 'package:chat/screens/chat/mobile_chat_screen/chat_list/chat_list.dart';
import 'package:chat/screens/setting/change_wallpaper_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileChatScreen extends StatefulWidget {
  final String contactUid;
  final UserModel user;
  const MobileChatScreen(
      {super.key, required this.contactUid, required this.user});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  File? fileSending;
  MessageEnum? fileSendingType;
  String contactName = '';
  String wallpaperAddress = 'assets/wallpapers/default_wallpaper.jpg';
  @override
  void initState() {
    wallpaperAddress = ChangeWallpaperPreview.onChangeWallpaperNotifier.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<MobileChatScreenBloc>(create: (context) {
          final cartBloc = MobileChatScreenBloc(
              chatRepository: chatRepository, contactUid: widget.contactUid);
          return cartBloc;
        }),
        BlocProvider<ChatListBloc>(create: (context) {
          final chatListBloc = ChatListBloc(
              chatRepository: chatRepository, contactUid: widget.contactUid);
          return chatListBloc;
        }),
        BlocProvider<BottomChatFieldBloc>(create: (context) {
          final bottomChatFieldBloc = BottomChatFieldBloc(
              chatRepository: chatRepository,
              contactUid: widget.contactUid,
              authRepository: authRepository);
          return bottomChatFieldBloc;
        }),
      ],
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: BlocProvider<MobileChatScreenBloc>(
            create: (BuildContext context) {
              final mobileChatScreenBloc = context.read<MobileChatScreenBloc>();
              mobileChatScreenBloc.add(MobileChatScreenStarted());
              return mobileChatScreenBloc;
            },
            child: BlocBuilder<MobileChatScreenBloc, MobileChatScreenState>(
                builder: (context, state) {
              if (state is MobileChatScreenLoading) {
                return const CupertinoActivityIndicator();
              } else if (state is MobileChatScreenError) {
                return Container();
              } else if (state is MobileChatScreenSuccess) {
                return StreamBuilder(
                  stream: state.contactUserModelStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CupertinoActivityIndicator();
                    }
                    final contactModel = snapshot.data;
                    contactName = contactModel!.name;
                    return Row(
                      children: [
                        contactModel.profilePic != ''
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: CachedNetworkImageProvider(
                                    contactModel.profilePic),
                                radius: 20,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/no_profile_pic.png'),
                                radius: 20,
                              ),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return ContactDetailScreen(
                                  currentUserModelData: state.contactUserModel);
                            })));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contactModel.name,
                                style: themeData.textTheme.bodySmall!.copyWith(
                                    color:
                                        themeData.appBarTheme.foregroundColor),
                              ),
                              Text(
                                contactModel.isOnline ? 'online' : 'offline',
                                style: themeData.textTheme.bodySmall!.copyWith(
                                    color:
                                        themeData.appBarTheme.foregroundColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                throw Exception('state is not supported');
              }
            }),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.video_call,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(wallpaperAddress),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: [
            ChatList(
              contactUid: widget.contactUid,
              user: widget.user,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: ButtomChatField(
                contactUid: widget.contactUid,
                currentUserModel: widget.user,
                contactName: contactName,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
