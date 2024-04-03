import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  final String text;
  const SocialIcon({
    Key key,
    this.iconSrc,
    this.press, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press as void Function(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: COLOR_GREY_LIGHT,
          ),
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconSrc,
              height: 20,
              width: 20,
            ),
            SizedBox(width: 5,),
            Text("Continue with $text")
          ],
        ),
      ),
    );
  }
}
