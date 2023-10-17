import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat/contact_detail/contact_profile_photo.dart';
import 'package:flutter/material.dart';

class ContactDetailScreen extends StatelessWidget {
  final UserModel currentUserModelData;

  const ContactDetailScreen({
    super.key,
    required this.currentUserModelData,
  });
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: defaultScrollPhysics,
          slivers: [
            SliverAppBar(
                foregroundColor: Colors.black,
                elevation: 5,
                shadowColor: Colors.grey,
                floating: true,
                backgroundColor: themeData.scaffoldBackgroundColor,
                expandedHeight: 200,
                flexibleSpace: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ContactProfilePhoto(
                          currentUserModelData: currentUserModelData,
                        );
                      }));
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: CachedNetworkImageProvider(
                              currentUserModelData.profilePic),
                        ),
                      ],
                    ))),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    currentUserModelData.name,
                    style: themeData.textTheme.headlineMedium!
                        .copyWith(color: themeData.primaryColor),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    currentUserModelData.phoneNumber,
                    style: themeData.textTheme.headlineSmall!.copyWith(
                        color: themeData.primaryColor.withOpacity(0.5)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      'Last seen  ....',
                      style: themeData.textTheme.bodyMedium!.copyWith(
                          color: themeData.appBarTheme.backgroundColor),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.phone,
                              color: themeData.appBarTheme.backgroundColor),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Audio',
                            style: themeData.textTheme.bodySmall!.copyWith(
                                color: themeData.appBarTheme.backgroundColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Column(
                        children: [
                          Icon(Icons.video_call,
                              color: themeData.appBarTheme.backgroundColor),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Video',
                            style: themeData.textTheme.bodySmall!.copyWith(
                                color: themeData.appBarTheme.backgroundColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.search,
                                color: themeData.appBarTheme.backgroundColor),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Search',
                              style: themeData.textTheme.bodySmall!.copyWith(
                                  color: themeData.appBarTheme.backgroundColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 6,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
