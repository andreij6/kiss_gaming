import 'package:flutter/material.dart';

class ConfigurationRowItem extends StatelessWidget {

  String category;
  String value;
  TextStyle textStyle;

  ConfigurationRowItem({Key? key, required this.category, required this.value, required this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: textStyle),
            Text(value, style: textStyle.copyWith(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
          ],
        ),
      );
  }
  
}