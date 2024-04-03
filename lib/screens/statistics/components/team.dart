import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/team.dart';

class TeamLogoName extends StatelessWidget {
  final Team team;
  final double width;
  final bool isHome;
  final bool isHomePage;
  const TeamLogoName({Key key, this.team, this.width, this.isHome, this.isHomePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: team.logoUrl,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: marginLarge),
          FittedBox(
            child: Text(
              team.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: isHomePage? COLOR_WHITE: COLOR_BLACK, fontSize: fontSizeStandard),
            ),
          ),
          SizedBox(height: marginLarge),
          Text(
            isHome ? AppLocale.home.getString(context) : AppLocale.away.getString(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isHomePage? COLOR_WHITE.withOpacity(0.5): COLOR_BLACK.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
