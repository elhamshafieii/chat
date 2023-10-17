import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/screens/mobile_layout/mobile_layout_screen.dart';
import 'package:chat/screens/user_information/bloc/user_information_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  ThemeData? themeData;
  File? image;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await selectProfilePicFromCameraOrGalley(
        context: context, themeData: themeData!);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                image == null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: CachedNetworkImageProvider(
                            "gs://chat-3a33d.appspot.com/profilePic/no_profile_pic.png"))
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {
                          selectImage();
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                ),
                BlocProvider<UserInformationBloc>(
                  create: (context) {
                    final bloc = UserInformationBloc(
                      authRepository: authRepository,
                    );
                    bloc.stream.forEach((state) {
                      if (state is UserInformationError) {
                        showSnackBar(context: context, content: state.error);
                      } else if (state is UserInformationLoading) {
                      } else if (state is UserInformationSuccess) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return MobileLayoutScreen(
                            user: state.userModel,
                          );
                        }), (route) => false);
                      }
                    });
                    bloc.add(UserInformationStarted());
                    return bloc;
                  },
                  child: BlocBuilder<UserInformationBloc, UserInformationState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            BlocProvider.of<UserInformationBloc>(context).add(
                                UserInformationOkButtomClicked(
                                    userName: nameController.text,
                                    profilePic: image));
                          },
                          icon: const Icon(Icons.check));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
