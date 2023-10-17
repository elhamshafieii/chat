

import 'package:chat/common/utils/colors.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/screens/setting/wallpaper_collection_items.dart';
import 'package:flutter/material.dart';

class ChangeThemeCollection extends StatelessWidget {
  const ChangeThemeCollection({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Wallpaper'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: GridView.builder(
                shrinkWrap: true,
                physics: defaultScrollPhysics,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemCount: 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const ChangeThemeCollectionItem(
                        collectionName: 'Bright',
                        collectionAddress:
                            'assets/wallpapers/bright/wallpaper_bright1.jpg',
                      );
                    case 1:
                      return const ChangeThemeCollectionItem(
                        collectionName: 'Dark',
                        collectionAddress:
                            'assets/wallpapers/dark/wallpaper_dark1.jpg',
                      );

                    case 2:
                      return const ChangeThemeCollectionItem(
                        collectionName: 'Solid',
                        collectionAddress:
                            'assets/wallpapers/solid/wallpaper_solid1.jpg',
                      );
                    case 3:
                      return const ChangeThemeCollectionItem(
                        collectionName: 'My photos',
                        collectionAddress:
                            'assets/wallpapers/solid/wallpaper_solid1.jpg',
                      );
                    default:
                      return const SizedBox(
                        height: 10,
                        width: 10,
                      );
                  }
                }),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(24),
              child: const Row(
                children: [
                  Icon(
                    Icons.wallpaper,
                    color: LightThemeColors.tabColor,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Default Wallpaper')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChangeThemeCollectionItem extends StatelessWidget {
  final String collectionName;
  final String collectionAddress;
  const ChangeThemeCollectionItem({
    super.key,
    required this.collectionName,
    required this.collectionAddress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WallpaperCollectionItems(
            title: collectionName,
          );
        }));
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(collectionAddress),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(collectionName)
          ],
        ),
      ),
    );
  }
}
