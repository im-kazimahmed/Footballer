import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footballer/models/h2h_model.dart';
import 'package:footballer/models/lineups_model.dart';
import 'package:footballer/models/substitutes_model.dart';
import 'package:footballer/models/team.dart';
import 'package:graphview/GraphView.dart';

import '../../api/football_api.dart';
import '../../constants.dart';
import '../../models/match.dart';
import '../../models/players_statistics.dart';

class HeadToHead extends StatefulWidget {
  final SoccerMatch match;
  const HeadToHead({Key key, this.match}) : super(key: key);

  @override
  _HeadToHeadState createState() => _HeadToHeadState();
}

class _HeadToHeadState extends State<HeadToHead> {
  List<HeadToHeadModel> homeH2H;
  List<HeadToHeadModel> awayLineups;
  var _isLoading = false;
  var _homeLineUpLength = 0;
  var _awayLineUpLength = 0;
  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    isLoading = true;
    homeH2H = await FootballApi.getH2HData(
        teamHomeId: widget.match.home.id,teamAwayId: widget.match.away.id);

    homeH2H.sort((a, b) => a.leagueSeason.compareTo(b.leagueSeason));


    // awayLineups = await FootballApi.getTeamLineUps(
    //     widget.match.away.id);

    // print(homeLineups[0].team.name);
    // print(homeLineups[0].substitutes);
    // print(awayLineups)

    isLoading = false;
    _homeLineUpLength = homeH2H.length;
    // _awayLineUpLength = awayLineups.length;
  }

  set isLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_isLoading)
          Center(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ))
        else
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: _size.height * _homeLineUpLength / 4,
                child: ListView.builder(
                    itemCount: _homeLineUpLength,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

                      return Column(
                        children: [
                          Row(
                            children: [
                              FittedBox(
                                child: Image(image: NetworkImage(homeH2H[index].leagueLogoUrl.toString()), height: 60, width: 60,)
                              ),
                              FittedBox(
                                child: Text(
                                  "${homeH2H[index].leagueName} ${homeH2H[index].leagueSeason.toString()}",
                                  style: TextStyle(
                                    fontSize: fontSizeLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Container(
                            width: _size.width,
                            decoration: BoxDecoration(
                              color: COLOR_WHITE,
                              boxShadow: [
                                BoxShadow(
                                  color: COLOR_GREY_LIGHT
                                ),
                              ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(homeH2H[index].homeTeamName),
                                        SizedBox(width: 10,),
                                        Image(image: NetworkImage(homeH2H[index].homeTeamLogoUrl.toString()), height: 30,),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "${homeH2H[index].homeTeamGoals.toString()}:${homeH2H[index].awayTeamGoals.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Image(image: NetworkImage(homeH2H[index].awayTeamLogoUrl.toString()), height: 30,),
                                        SizedBox(width: 10,),
                                        Text(homeH2H[index].awayTeamName),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                        ],
                      );
                    }
                ),
              ),
            ),
          )
      ],
    );
  }
}
