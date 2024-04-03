import 'package:flutter/material.dart';

import '../constants.dart';

class BySigningUpYouAgreeToOurTerms extends StatelessWidget {
  final bool login;
  final Function press;
  const BySigningUpYouAgreeToOurTerms({
    Key key,
    this.login = true,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              login ? "By signing in you agree to our " : "By signing up you agree to our ",
              style: TextStyle(
                  color: COLOR_GREY_LIGHT
              ),
            ),
            GestureDetector(
              onTap: press as void Function(),
              child: Text(
                "Terms",
                style: const TextStyle(
                  color: COLOR_BLACK,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "and ",
              style: TextStyle(
                color: COLOR_GREY_LIGHT
              ),
            ),
            GestureDetector(
              onTap: press as void Function(),
              child: Text(
                "Conditions of Use",
                style: const TextStyle(
                  color: COLOR_BLACK,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
