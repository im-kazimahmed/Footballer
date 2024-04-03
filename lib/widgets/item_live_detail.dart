import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:footballer/constants.dart';

class LiveDetailItem extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String subTitle2;
  const LiveDetailItem(
      {Key key,
      this.image,
      @required this.title,
      this.subTitle = "",
      this.subTitle2 = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: marginStandard,
        right: marginLarge,
        bottom: marginStandard
      ),
      padding: const EdgeInsets.symmetric(
          vertical: marginStandard, horizontal: marginLarge),
      decoration: BoxDecoration(
        color: COLOR_PRIMARY.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radiusStandard),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(image),
          ),
          SizedBox(width: marginLarge),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: COLOR_WHITE),
              ),
              SizedBox(height: marginStandard),
              Text(
                subTitle,
                style: TextStyle(color: COLOR_WHITE),
              ),
              Visibility(
                visible: subTitle2.length > 0,
                child: Container(
                  margin: const EdgeInsets.only(top: marginStandard),
                  child: Text(
                    subTitle2,
                    style: TextStyle(color: COLOR_WHITE),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
