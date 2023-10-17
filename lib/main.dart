import 'dart:io';

import 'package:chat/common/utils/theme.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/screens/landing/landing_screen.dart';
import 'package:chat/screens/mobile_layout/bloc/mobile_layout_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  createFolder() async {
    final permissionStatus = await Permission.manageExternalStorage.request();
    final dir = await getExternalStorageDirectory();
    final dirPath = dir!.path;
    if (permissionStatus.isGranted) {
      final imagPath = Directory('$dirPath/images');
      final videoPath = Directory('$dirPath/videos');
      final audioPath = Directory('$dirPath/audioa');
      final filePath = Directory('$dirPath/files');
      if (!(await imagPath.exists())) {
        imagPath.create();
      }
      if (!(await videoPath.exists())) {
        videoPath.create();
      }
      if (!(await audioPath.exists())) {
        audioPath.create();
      }
      if (!(await filePath.exists())) {
        filePath.create();
      }
    } else {
      showSnackBar(context: context, content: 'Storage Permission Denies.');
    }
  }

  @override
  void initState() {
    createFolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SelectThemeEnum>(
      valueListenable: themeChangeNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MobileLayoutBloc>(create: (context) {
              final mobileLayoutBloc =
                  MobileLayoutBloc(authRepository: authRepository);
              return mobileLayoutBloc;
            }),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat',
            theme: getThemeData(value),
            home: const LandingScreen(),
          ),
        );
      },
    );
  }
}
