
import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icon.png',
            width: 100,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(message,
              style:
                  themeData.textTheme.bodyLarge!.copyWith(color: Colors.black)),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MyApp();
              }));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_outlined,
                  size: 25,
                ),
                SizedBox(
                  width: 4,
                ),
                Text('Retry'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
