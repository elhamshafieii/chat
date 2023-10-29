import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/setting/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const ProfileScreen({super.key, required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  late StreamSubscription<ProfileScreenState>? stateSubscription;

  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: BlocProvider<ProfileScreenBloc>(
        create: (BuildContext context) {
          final bloc = ProfileScreenBloc(authRepository: authRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProfileScreenError) {
              showSnackBar(context: context, content: state.error);
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          physics: defaultScrollPhysics,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        widget.userModel.profilePic != ''
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.userModel.profilePic,
                                ),
                                radius: 70,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/no_profile_pic.png'),
                                radius: 70,
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              image = await selectProfilePicFromCameraOrGalley(
                                context: context,
                                themeData: themeData,
                              );
                              if (context.mounted) {
                                if (image != null) {
                                  if (!(state is ProfileScreenLoading)) {
                                    BlocProvider.of<ProfileScreenBloc>(context).add(
                                        ProfileScreenChangeProfilePicButtonClickes(
                                            profilePic: image));
                                  }
                                }
                              }
                              setState(() {});
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: LightThemeColors.tabColor),
                              child: Center(
                                  child: state is ProfileScreenLoading
                                      ? CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        )),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                ListTile(
                    title: Text(
                      'Name',
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        widget.userModel.name.toUpperCase(),
                        style: themeData.textTheme.bodySmall,
                      ),
                    ),
                    leading: const Icon(Icons.person, color: Colors.grey),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: LightThemeColors.tabColor,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Text(
                    'This is not your username or pin. This name will be visible to your WhatsApp contacts.',
                    style: themeData.textTheme.bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
                ListTile(
                    title: Text(
                      'About',
                      style: themeData.textTheme.bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'about',
                        style: themeData.textTheme.bodySmall,
                      ),
                    ),
                    leading:
                        const Icon(Icons.info_outlined, color: Colors.grey),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: LightThemeColors.tabColor,
                      ),
                    )),
                const SizedBox(
                  height: 12,
                ),
                ListTile(
                  title: Text(
                    'Phone',
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      widget.userModel.phoneNumber,
                      style: themeData.textTheme.bodySmall,
                    ),
                  ),
                  leading: const Icon(Icons.phone, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
