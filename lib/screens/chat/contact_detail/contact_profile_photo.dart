import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/colors.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';

class ContactProfilePhoto extends StatelessWidget {
  final UserModel contactUserModel;

  const ContactProfilePhoto({
    super.key,
    required this.contactUserModel,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactUserModel.name),
        backgroundColor: DarkThemeColors.backgroundColor,
      ),
      backgroundColor: DarkThemeColors.backgroundColor,
      body: Center(
        child: CachedNetworkImage(imageUrl: contactUserModel.profilePic),
      ),
    );
  }
}
