import 'package:chat/common/utils/colors.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/screens/setting/change_wallpaper_collection.dart';
import 'package:chat/screens/setting/theme_change_alert_dialog.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  final String title;

  const ChatsScreen({super.key, required this.title});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          physics: defaultScrollPhysics,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                'Dispaly',
                style: themeData.textTheme.bodySmall!
                    .copyWith(color: LightThemeColors.greyColor),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    //barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        // contentTextStyle:
                        //     themeData.dialogTheme.contentTextStyle,
                        // titleTextStyle: themeData.dialogTheme.titleTextStyle,
                        title: Text(
                          'Choose Theme',
                        ),
                        content: ThemeChangeAlertDialog(),
                      );
                    });
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.brightness_6_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Light',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ChangeThemeCollection();
                }));
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.wallpaper,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Wallpaper'),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
