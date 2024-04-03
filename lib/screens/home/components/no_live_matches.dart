import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';

class NoLiveMatches extends StatelessWidget {
  final double height;
  const NoLiveMatches({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: marginXLarge,
        vertical: marginStandard,
      ),
      decoration: BoxDecoration(
        color: Color(0x5565FFED),
        borderRadius: BorderRadius.all(
          Radius.circular(radiusStandard),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset("assets/images/schedule.png"),
          Text(AppLocale.noLiveMatches.getString(context)),
        ],
      ),
    );
  }
}
