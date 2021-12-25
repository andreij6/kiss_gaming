import 'package:flutter/material.dart';
import 'package:raffle_ui/constants/kiss/kiss_colors.dart';

class AppCard extends StatelessWidget {

  Widget cardBody;

  AppCard({Key? key, required this.cardBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: KissColors.cardColor,
      child: Container(
        width: 475.0,
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
          child: cardBody
      ),
    );
  }

}