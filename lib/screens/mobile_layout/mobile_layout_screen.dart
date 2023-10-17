import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/auth/login_screen/login_screen.dart';
import 'package:chat/screens/chat/chat_contact_list/chat_contact_list.dart';
import 'package:chat/screens/mobile_layout/bloc/mobile_layout_bloc.dart';
import 'package:chat/screens/select_contact/select_contacts_screen.dart';
import 'package:chat/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileLayoutScreen extends StatefulWidget {
  final UserModel user;

  const MobileLayoutScreen({super.key, required this.user});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  MobileLayoutBloc? mobileLayoutBloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<MobileLayoutBloc>().add(MobileLayoutResumed());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        context
            .read<MobileLayoutBloc>()
            .add(MobileLayoutInactiveDetachedPausedHidden());
        break;
    }
  }

  @override
  void initState() {
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    tabBarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
            onPressed: () {
              if (tabBarController.index == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SelectContactsScreen(
                    user: widget.user,
                  );
                }));
              } else {}
            }),
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Chat',
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {},
            ),
            PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SettingScreen(
                      user: widget.user,
                    );
                  }));
                }
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(
                    'Create Group',
                    style: themeData.textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Settings',
                    style: themeData.textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  child: Text(
                    'Exit',
                    style: themeData.textTheme.bodyMedium,
                  ),
                  onTap: () async{
                    await authRepository.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        (MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        })),
                        (route) => true);
                  },
                )
              ],
            ),
          ],
          bottom: TabBar(
            physics: defaultScrollPhysics,
            controller: tabBarController,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              SizedBox(
                width: 100,
                child: Tab(text: 'CHAtS'),
              ),
              SizedBox(
                width: 100,
                child: Tab(text: 'STATUS'),
              ),
              SizedBox(
                width: 100,
                child: Tab(text: 'CALLS'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: [
            ChatContactsList(
              user: widget.user,
            ),
            Text('Calls'),
            Text('Calls')
          ],
        ),
      ),
    );
  }
}
