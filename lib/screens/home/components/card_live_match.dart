import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/match.dart';

import '../../background.dart';
import '../../statistics/components/team.dart';

class LiveMatchCard extends StatelessWidget {
  final SoccerMatch match;
  final int index;
  const LiveMatchCard({Key key, this.index, this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _cardWidth = _size.width / 2 - marginStandard * 2;
    final _logoWidth = _cardWidth * 0.3 - marginStandard * 2;
    return Container(
      width: _size.width - 20,
      margin: const EdgeInsets.symmetric(
        horizontal: marginStandard,
        // vertical: 5,
      ),
      padding: const EdgeInsets.all(marginStandard),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 6,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        image: DecorationImage(
          image: AssetImage('assets/images/premier-league_cover2.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              match.league.name.toString(),
              style: TextStyle(
                color: COLOR_WHITE,
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TeamLogoName(
                isHome: true,
                width: _size.width * 0.3,
                team: match.home,
                isHomePage: true,
              ),
              Container(
                width: _size.width * 0.20,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        match.goal.home.toString(),
                        style: TextStyle(
                          fontSize: fontSizeXXLarge,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        " : ",
                        style: TextStyle(
                            fontSize: fontSizeXXLarge,
                            color: Colors.white),
                      ),
                      Text(
                        match.goal.away.toString(),
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
                team: match.away,
                isHomePage: true,
              ),
            ],
          ),
          FittedBox(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: COLOR_GREEN)
              ),
              child: Text(
                "${AppLocale.time.getString(context)}: ${match.fixture.status.elapsedTime.toString()}",
                style: TextStyle(color: COLOR_GREEN),
              ),
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   width: _cardWidth * 1.3,
    //   margin: const EdgeInsets.symmetric(
    //     horizontal: marginStandard,
    //     vertical: marginLarge,
    //   ),
    //   padding: const EdgeInsets.all(marginStandard),
    //   decoration: BoxDecoration(
    //     color: COLOR_BLUE,
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(12),
    //     ),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.2),
    //         spreadRadius: 5,
    //         blurRadius: 6,
    //         offset: Offset(0, 0), // changes position of shadow
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Container(
    //             width: _cardWidth * 0.5,
    //             child: Row(
    //               children: [
    //                 Container(
    //                   width: _logoWidth,
    //                   margin: const EdgeInsets.only(bottom: marginLarge),
    //                   child: CachedNetworkImage(
    //                     fit: BoxFit.cover,
    //                     imageUrl: match.home.logoUrl,
    //                     placeholder: (context, url) => Center(
    //                       child: CircularProgressIndicator(),
    //                     ),
    //                     errorWidget: (context, url, error) =>
    //                         Icon(Icons.error),
    //                   ),
    //                 ),
    //                 SizedBox(width: 5),
    //                 Container(
    //                   width: _logoWidth,
    //                   margin: const EdgeInsets.only(bottom: marginLarge),
    //                   child: CachedNetworkImage(
    //                     fit: BoxFit.cover,
    //                     imageUrl: match.away.logoUrl,
    //                     placeholder: (context, url) => Center(
    //                       child: CircularProgressIndicator(),
    //                     ),
    //                     errorWidget: (context, url, error) =>
    //                         Icon(Icons.error),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 6,
    //             ),
    //             decoration: BoxDecoration(
    //               color: COLOR_RED,
    //               border: Border.all(color: COLOR_RED),
    //               borderRadius: BorderRadius.all(
    //                 Radius.circular(12),
    //               ),
    //             ),
    //             child: Text(AppLocale.live.getString(context),
    //               style: TextStyle(color: COLOR_WHITE),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           match.league.name,
    //           style: TextStyle(
    //             color: COLOR_WHITE.withOpacity(0.5)
    //           ),
    //         ),
    //       ),
    //       SizedBox(height: marginStandard,),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               match.home.name,
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 2,
    //               softWrap: false,
    //               style: TextStyle(
    //                 color: COLOR_WHITE,
    //               ),
    //             ),
    //             Text(
    //               match.goal.home.toString(),
    //               style: TextStyle(
    //                 color: COLOR_WHITE,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 5,),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               match.away.name,
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 2,
    //               softWrap: false,
    //               style: TextStyle(
    //                 color: COLOR_WHITE,
    //               ),
    //             ),
    //             Text(
    //               match.goal.away.toString(),
    //               style: TextStyle(
    //                 color: COLOR_WHITE,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
