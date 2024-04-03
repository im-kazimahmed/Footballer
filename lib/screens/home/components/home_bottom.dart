import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/screens/live_match_details.dart';
import 'package:footballer/screens/home/components/card_live_match.dart';
import 'package:footballer/screens/home/components/no_live_matches.dart';

import '../../../languages.dart';

class HomeBottom extends StatelessWidget {
  final limit;
  final Function onTap;
  final Function onViewAllTap;
  final List<SoccerMatch> liveMatches;
  HomeBottom({Key key, this.liveMatches, this.onTap, this.onViewAllTap, this.limit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: marginLarge,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(AppLocale.liveMatch.getString(context),
                  style: TextStyle(
                    fontSize: fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Visibility(
                // visible: liveMatches != null,
                visible: onViewAllTap != null,
                child: InkWell(
                  onTap: onViewAllTap,
                  child: Text(AppLocale.viewAll.getString(context),
                    style: TextStyle(
                      color: COLOR_WHITE,
                      fontSize: fontSizeStandard,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: liveMatches != null && liveMatches.length > 0
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: liveMatches.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => LiveMatchDetails(
                      match: liveMatches[index],
                    ),
                  ),
                ),
                child: LiveMatchCard(
                  index: index,
                  match: liveMatches[index],
                ),
              );
            },
          )
              : NoLiveMatches(),
        ),
      ],
    );
  }
}
