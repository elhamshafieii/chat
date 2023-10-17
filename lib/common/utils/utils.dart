import 'dart:io';

import 'package:chat/common/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ScrollPhysics defaultScrollPhysics = const BouncingScrollPhysics();

enum SelectThemeEnum { system, light, dark }

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1),
  ));
}

Future<File?> pickImageFromGalleryOrCamera(
    BuildContext context, ImageSource imageSource) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGalleryOrCamera(
    BuildContext context, ImageSource imageSource) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickVideo(source: imageSource);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickimageOrVideoFrom (
    BuildContext context, ImageSource imageSource) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickVideo(source: imageSource);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickFile({required BuildContext context, required FileType fileType}) async {
  File? file;
  try {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result != null) {
      file = File(result.files.single.path!);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return file;
}

Future<File?> selectProfilePicFromCameraOrGalley(
    {required BuildContext context, required ThemeData themeData}) async {
  File? image;
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 230,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 2, 24, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 35,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2.5)),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile Photo',
                      style: themeData.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.delete)
                  ],
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                            image = await pickImageFromGalleryOrCamera(
                                context, ImageSource.camera);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey.shade700)),
                            child: const Icon(
                              Icons.camera_alt,
                              color: LightThemeColors.tabColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Camera',
                            style: themeData.textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                            image = await pickImageFromGalleryOrCamera(
                                context, ImageSource.gallery);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey.shade700)),
                            child: const Icon(Icons.add_photo_alternate,
                                color: LightThemeColors.tabColor),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Gallery',
                          style: themeData.textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
  return image;
}

ValueNotifier<SelectThemeEnum> themeChangeNotifier =
    ValueNotifier(SelectThemeEnum.system);
