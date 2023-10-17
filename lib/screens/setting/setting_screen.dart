import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/setting/chats.dart';
import 'package:chat/screens/setting/profile_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  final UserModel user;
  const SettingScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
          physics: defaultScrollPhysics,
          child: Column(children: [
            ItemSettings(
                user.profilePic != ''
                    ? CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profilePic), 
                        radius: 30,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage('assets/images/no_profile_pic.png'),
                        radius: 30,
                      ),
                subtitle: 'about',
                title: user.name,
                trailing: const Icon(Icons.qr_code_2),
                nextScreen: ProfileScreen(
                  userModel: user,
                )),
            const Divider(),
            const ItemSettings(Icon(Icons.key_outlined),
                subtitle: 'Security notifications,change number',
                title: 'Account',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Account',
                )),
            const ItemSettings(Icon(Icons.lock),
                subtitle: 'Block contacts, disappearing messages',
                title: 'Privacy',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Privacy',
                )),
            const ItemSettings(Icon(Icons.person_2_sharp),
                subtitle: 'Create, edit, profile photo',
                title: 'Avatar',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Avatar',
                )),
            const ItemSettings(Icon(Icons.chat),
                subtitle: 'Theme, wallpapers, chat history',
                title: 'Chats',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Chats',
                )),
            const ItemSettings(Icon(Icons.notifications),
                subtitle: 'Message, group & call tones',
                title: 'Notifications',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Notifications',
                )),
            const ItemSettings(Icon(Icons.circle_outlined),
                subtitle: 'Nanetwork usage, auto-download',
                title: 'Storage and data',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Storage and data',
                )),
            const ItemSettings(Icon(Icons.language),
                subtitle: 'English',
                title: 'App Language',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'App Language',
                )),
            const ItemSettings(Icon(Icons.help_outline),
                subtitle: 'Help center, contact us, privacy policy',
                title: 'Help',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Help',
                )),
            const ItemSettings(Icon(Icons.group),
                subtitle: '',
                title: 'Invite a friend',
                trailing: SizedBox(),
                nextScreen: ChatsScreen(
                  title: 'Invite a friend',
                ))
          ])),
    );
  }
}

class ItemSettings extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget leading;
  final Widget nextScreen;
  const ItemSettings(this.leading,
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return nextScreen;
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: ListTile(
            title: Text(
              title,
              style: themeData.textTheme.bodyLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                subtitle,
                style: themeData.textTheme.bodySmall,
              ),
            ),
            leading: leading,
            trailing: trailing),
      ),
    );
  }
}
