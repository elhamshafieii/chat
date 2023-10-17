import 'package:chat/common/utils/utils.dart';
import 'package:flutter/material.dart';

class ThemeChangeAlertDialog extends StatefulWidget {
  const ThemeChangeAlertDialog({super.key});
  @override
  State<ThemeChangeAlertDialog> createState() => _ThemeChangeAlertDialogState();
}

class _ThemeChangeAlertDialogState extends State<ThemeChangeAlertDialog> {
  SelectThemeEnum? _theme = themeChangeNotifier.value;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          RadioListTile<SelectThemeEnum>(
            title: Text(
              'System default',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: _theme,
            onChanged: (SelectThemeEnum? value) {
              setState(() {
                _theme = value;
              });
              themeChangeNotifier.value = value!;
              Navigator.of(context).pop();
            },
            value: SelectThemeEnum.system,
          ),
          RadioListTile<SelectThemeEnum>(
            title: Text(
              'Light',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: _theme,
            onChanged: (SelectThemeEnum? value) {
              setState(() {
                _theme = value;
              });
              themeChangeNotifier.value = value!;
              Navigator.of(context).pop();
            },
            value: SelectThemeEnum.light,
          ),
          RadioListTile<SelectThemeEnum>(
            title: Text(
              'Dark',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: _theme,
            onChanged: (SelectThemeEnum? value) {
              setState(() {
                _theme = value;
              });
              themeChangeNotifier.value = value!;
              Navigator.of(context).pop();
            },
            value: SelectThemeEnum.dark,
          ),
        ],
      ),
    );
  }
}
