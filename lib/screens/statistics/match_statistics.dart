import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/api/football_api.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/models/statistic.dart';
import 'package:footballer/screens/background.dart';
import 'package:footballer/screens/statistics/components/row.dart';
import 'package:footballer/screens/statistics/components/team.dart';
import 'package:footballer/screens/statistics/head_to_head.dart';
import 'package:footballer/screens/statistics/lineups.dart';
import 'dart:math' as math;

import 'package:footballer/screens/statistics/players_summary.dart';
import 'package:footballer/screens/statistics/standings.dart';

import '../../models/standings_model.dart';


class MatchStatistics extends StatefulWidget {
  final SoccerMatch match;
  final bool isLive;
  const MatchStatistics({Key key, this.match, this.isLive}) : super(key: key);

  @override
  _MatchStatisticsState createState() => _MatchStatisticsState();
}

class _MatchStatisticsState extends State<MatchStatistics> {
  List<Statistic> homeStatistics;
  List<Statistic> awayStatistics;
  var _isLoading = false;
  var _homeStatLength = 0;
  var _awayStatLength = 0;
  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    isLoading = true;
    homeStatistics = await FootballApi.getTeamStatistics(
        widget.match.fixture.id, widget.match.home.id);

    awayStatistics = await FootballApi.getTeamStatistics(
        widget.match.fixture.id, widget.match.away.id);
    isLoading = false;
    _homeStatLength = homeStatistics.length;
    _awayStatLength = awayStatistics.length;

    // print("Home:: homestats :: ${homeStatistics.toList()}");
    // print("Home:: awaystats :: ${awayStatistics.toList()}");
  }

  set isLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final _statLength =
        _homeStatLength >= _awayStatLength ? _awayStatLength : _homeStatLength;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: COLOR_PRIMARY,
      //   title: Text(widget.match.league.name.toString()),
      //   elevation: 0,
      // ),
      body: Stack(
        children: [
          TransparentBackground(
            isHome: false,
          ),
          //top header
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusStandard),
              bottomRight: Radius.circular(radiusStandard),
            ),
            child: Container(
              padding: const EdgeInsets.all(marginLarge),
              height: _size.height * 0.4,
              width: double.infinity,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: COLOR_WHITE)
                    ),
                    child: Icon(Icons.arrow_back, color: COLOR_WHITE,),
                  ),
                ),
                Text(
                  widget.match.league.name.toString(),
                  style: TextStyle(
                    color: COLOR_WHITE,
                    fontSize: fontSizeLarge
                  ),
                ),
                SizedBox(width: 20,),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Container(
              width: _size.width - 60,
              margin: const EdgeInsets.symmetric(
                horizontal: marginStandard,
                // vertical: 5,
              ),
              padding: const EdgeInsets.all(marginStandard),
              decoration: BoxDecoration(
                color: COLOR_WHITE,
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      widget.match.league.name.toString(),
                      style: TextStyle(
                        color: COLOR_BLACK,
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
                        team: widget.match.home,
                        isHomePage: false,
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
                                  color: COLOR_BLACK,
                                ),
                              ),
                              Text(
                                " : ",
                                style: TextStyle(
                                  fontSize: fontSizeXXLarge,
                                  color: COLOR_BLACK,
                                ),
                              ),
                              Text(
                                widget.match.goal.away.toString(),
                                style: TextStyle(
                                  fontSize: fontSizeXXLarge,
                                  color: COLOR_BLACK,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TeamLogoName(
                        isHome: false,
                        width: _size.width * 0.3,
                        team: widget.match.away,
                        isHomePage: false,
                      ),
                    ],
                  ),
                  FittedBox(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: COLOR_GREEN,),
                      ),
                      child: Text(
                        "${AppLocale.time.getString(context)}: ${widget.match.fixture.status.elapsedTime.toString()}",
                        style: TextStyle(color: COLOR_GREEN,),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          Positioned(
            top: 350,
            child: Container(
              height: _size.height -350,
              width: _size.width,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TabBar(
                        unselectedLabelColor: Colors.black.withOpacity(0.5),
                        labelColor: Colors.white,
                        labelPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        indicator: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        tabs: [
                          Tab(text: 'Stats'),
                          Tab(text: 'Summary'),
                          Tab(text: 'Lineups'),
                          Tab(text: 'H2H'),
                          Tab(text: 'Tables'),
                        ],
                        isScrollable: true,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // the content for the "Stats" tab
                          if (_isLoading)
                            Center(child: CircularProgressIndicator())
                          else _statLength > 0 ? ListView.builder(
                            itemCount: _statLength,
                            itemBuilder: (ctx, index) {
                              double homeValue = 0.0;
                              double awayValue = 0.0;
                              try {
                                if(homeStatistics[index].value.contains("%")) {
                                  String strippedValue = homeStatistics[index].value.replaceAll('%', '');
                                  homeValue = double.parse(strippedValue) / 50;
                                } else {
                                  homeValue = homeStatistics[index].value / 50;
                                }

                              } catch (e) {
                                homeValue = homeStatistics[index].value != null ?
                                homeStatistics[index].value / 50: 0.0;
                              }

                              try {
                                if(awayStatistics[index].value.contains("%")) {
                                  String strippedValue = awayStatistics[index].value.replaceAll('%', '');
                                  awayValue = double.parse(strippedValue) / 50;
                                } else {
                                  awayValue = awayStatistics[index].value / 50;
                                }

                              } catch (e) {
                                awayValue = awayStatistics[index].value != null ?
                                awayStatistics[index].value / 50: 0.0;
                              }

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: marginLarge,
                                  vertical: marginStandard,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: marginXLarge,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          homeStatistics[index].value.toString(),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(homeStatistics[index].type.toString()),
                                          ),
                                        ),
                                        Text(
                                          awayStatistics[index].value.toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Team 2 progress bar
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationY(math.pi),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.transparent,
                                                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                                  value: homeValue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Spacer to create a gap between the two progress bars
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              LinearProgressIndicator(
                                                backgroundColor: Colors.transparent,
                                                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                                value: awayValue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ): Center(child: Text("No stats available right now"),),
                          // the content for the "Summary" Tab
                          PlayersSummary(match: widget.match),
                          // the content for the "Lineups" tab
                          LineUps(match: widget.match,),
                          // the content for the "H2H" tab
                          HeadToHead(match: widget.match,),
                          // the content for the "Tables" tab
                          Standings(match: widget.match,),
                          // TextButton(onPressed: () async {
                          //   List<StandingsModel> leagueStandings = await FootballApi.getLeagueStandings(
                          //         leagueId: widget.match.league.id);
                          //   final encoder = JsonEncoder.withIndent('  ');
                          //   final jsonStr = encoder.convert(leagueStandings[0].rank);
                          //   log(jsonStr.toString());
                          //
                          // }, child: Text("Test"))
                        ]
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //statistics list
          // Positioned(
          //   top: 100,
          //   child: Expanded(
          //     child: _isLoading
          //         ? Center(child: CircularProgressIndicator())
          //         : ListView.builder(
          //             itemCount: _statLength,
          //             itemBuilder: (ctx, index) {
          //               return StatisticRow(
          //                 // home: 2,
          //                 // away: 3,
          //                 // title: "tiot",
          //                 home: homeStatistics[index].value,
          //                 away: awayStatistics[index].value,
          //                 title: homeStatistics[index].type,
          //               );
          //             },
          //           ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
