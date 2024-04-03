import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPassword extends StatelessWidget {
  final bool login;
  final Function press;
  const ForgotPassword({
    Key key,
    this.login = true,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press as void Function(),
      child: Text(
        "Forgot Password",
        style: TextStyle(
            color: COLOR_GREY
        ),
      ),
    );
  }
}
