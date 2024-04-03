import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:footballer/components/or_divider.dart';
import 'package:footballer/components/social_icon.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hi, Welcome Back! ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32
              ),
            ),
            Icon(
              Icons.waving_hand,
              color: kYellowColor,
            )
          ],
        ),
        SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            "We are happy to see you again. Sign Up to your account",
            style: TextStyle(
                fontSize: 18,
                color: COLOR_GREY_LIGHT
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SocialIcon(
                iconSrc: "assets/icons/google.svg",
                text: "Google",
              ),
              SizedBox(height: 10,),
              SocialIcon(
                iconSrc: "assets/icons/apple.svg",
                text: "Apple",
              ),
            ],
          ),
        ),
        SizedBox(height: defaultPadding),
        OrDivider(),
      ],
    );
  }
}