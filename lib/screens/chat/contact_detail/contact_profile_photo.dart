import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';

class ContactProfilePhoto extends StatelessWidget {
  final UserModel currentUserModelData;

  const ContactProfilePhoto({
    super.key,
    required this.currentUserModelData,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUserModelData.name),
        backgroundColor: DarkThemeColors.backgroundColor,
      ),
      backgroundColor: DarkThemeColors.backgroundColor,
      body: Center(
        child: CachedNetworkImage(imageUrl: currentUserModelData.profilePic),
      ),
    );
  }
}
