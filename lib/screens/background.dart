import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:footballer/constants.dart';

class TransparentBackground extends StatelessWidget {
  final bool isHome;
  const TransparentBackground({Key key, @required this.isHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: _size.width * 0.7,
            child: Image.asset(IMG_LOGO_LIGHT),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: isHome ? Color.fromRGBO(255, 255, 255, 0.9): COLOR_WHITE.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
