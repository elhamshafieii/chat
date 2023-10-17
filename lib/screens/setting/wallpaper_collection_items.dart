import 'dart:convert';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/screens/setting/change_wallpaper_preview.dart';
import 'package:chat/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WallpaperCollectionItems extends StatelessWidget {
  final String title;
  const WallpaperCollectionItems({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: getwallPapers(title),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          final wallpapers = snapshot.data as List<String>;
          return GridView.builder(
              shrinkWrap: true,
              physics: defaultScrollPhysics,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChangeWallpaperPreview(
                        wallpaperAddresses: wallpapers,
                        index: index,
                      );
                    }));
                  },
                  child: Image.asset(wallpapers[index]),
                );
              });
        },
      ),
    );
  }
}

Future<List<String>> getwallPapers(String collectionName) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  debugPrint(manifestMap.toString());
  final imagePaths = manifestMap.keys.where((String key) {
    if (key.contains('assets/wallpapers/${collectionName.toLowerCase()}')) {
      return true;
    } else {
      return false;
    }
  }).toList();
  return imagePaths;
}
