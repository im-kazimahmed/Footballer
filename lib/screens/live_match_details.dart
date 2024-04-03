import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/screens/background.dart';
import 'package:footballer/screens/statistics/components/team.dart';
import 'package:footballer/widgets/item_live_detail.dart';

class LiveMatchDetails extends StatefulWidget {
  final SoccerMatch match;
  const LiveMatchDetails({Key key, this.match}) : super(key: key);

  @override
  _LiveMatchDetailsState createState() => _LiveMatchDetailsState();
}

class _LiveMatchDetailsState extends State<LiveMatchDetails> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PRIMARY,
        title: Text(AppLocale.liveMatchDetails.getString(context)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          TransparentBackground(
            isHome: false,
          ),
          Column(
            children: [
              //top header
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radiusStandard),
                  bottomRight: Radius.circular(radiusStandard),
                ),
                child: Container(
                  padding: const EdgeInsets.all(marginLarge),
                  // height: _size.height * 0.2,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(IMG_STADIUM1),
                      fit: BoxFit.cover,
                      opacity: 0.3
                    ),
                    color: COLOR_PRIMARY,
                  ),
                  child: Column(
                    children: [
                      //Live badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: COLOR_RED,
                          border: Border.all(color: COLOR_RED),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Text(AppLocale.live.getString(context),
                          style: TextStyle(color: COLOR_WHITE),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TeamLogoName(
                            isHome: true,
                            width: _size.width * 0.3,
                            team: widget.match.home,
                          ),
                          Container(
                            width: _size.width * 0.20,
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.match.goal.home.toString(),
                                    style: TextStyle(
                                      fontSize: fontSizeXXLarge,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: fontSizeXXLarge,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    widget.match.goal.away.toString(),
                                    style: TextStyle(
                                        fontSize: fontSizeXXLarge,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TeamLogoName(
                            isHome: false,
                            width: _size.width * 0.3,
                            team: widget.match.away,
                          ),
                        ],
                      ),
                      Text(
                        "${AppLocale.time.getString(context)}: ${widget.match.fixture.status.elapsedTime.toString()}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              //statistics list
              Expanded(
                child: ListView(
                  children: [
                    LiveDetailItem(
                      image: IMG_LEAGUE,
                      title: AppLocale.league.getString(context),
                      subTitle: widget.match.league.name ?? "N/A",
                    ),
                    LiveDetailItem(
                      image: IMG_VENUE,
                      title: AppLocale.venue.getString(context),
                      subTitle: widget.match.fixture.venue.name ?? "N/A",
                      subTitle2: widget.match.fixture.venue.city ?? "N/A",
                    ),
                    LiveDetailItem(
                      image: IMG_CLOCK,
                      title: AppLocale.status.getString(context),
                      subTitle: widget.match.fixture.status.long ?? "N/A",
                    ),
                    LiveDetailItem(
                      image: IMG_REFEREE,
                      title: AppLocale.referee.getString(context),
                      subTitle: widget.match.fixture.referee ?? "N/A",
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
