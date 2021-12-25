import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffle_ui/constants/kiss/kiss_colors.dart';

class RaffleStateItem extends StatelessWidget {

  bool isMoney;
  String category;
  String value;

  RaffleStateItem({Key? key, required this.category, required this.value, this.isMoney = true}) : super(key: key);

  var infoTextStyle = GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontSize: 16.0));
  var infoTitleTextStyle = GoogleFonts.openSans(textStyle: TextStyle(color: KissColors.infoTextColor, fontSize: 16.0, letterSpacing: 2.0));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(category, style: infoTitleTextStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text((isMoney ? "\$" : "") + value, style: infoTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
      ]
    );
  }
  
}