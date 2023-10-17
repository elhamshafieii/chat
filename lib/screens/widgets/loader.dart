import 'package:flutter/cupertino.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Align(
          alignment: Alignment.center, child: CupertinoActivityIndicator()),
    );
  }
}
