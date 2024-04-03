import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/models/h2h_model.dart';
import 'package:footballer/models/standings_model.dart';

import '../../api/football_api.dart';
import '../../models/match.dart';

class Standings extends StatefulWidget {
  final SoccerMatch match;
  const Standings({Key key, this.match}) : super(key: key);

  @override
  _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  List<StandingsModel> homeH2H;
  var _isLoading = false;
  var _homeLineUpLength = 0;
  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    isLoading = true;
    homeH2H = await FootballApi.getLeagueStandings(
      season: widget.match.league.season,
      leagueId: widget.match.league.id,
    );

    isLoading = false;
    _homeLineUpLength = homeH2H.length;
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
                height: _size.height + 200,
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(50.0),
                        1: FlexColumnWidth(),
                        2: FixedColumnWidth(50.0),
                        3: FixedColumnWidth(50.0),
                        4: FixedColumnWidth(50.0),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: COLOR_WHITE,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Pos',
                                  style: TextStyle(
                                    fontSize: fontSizeStandard
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Team',
                                  style: TextStyle(
                                      fontSize: fontSizeStandard
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                      fontSize: fontSizeStandard
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'W',
                                  style: TextStyle(
                                      fontSize: fontSizeStandard
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Pts',
                                  style: TextStyle(
                                      fontSize: fontSizeStandard
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final row in homeH2H)
                          TableRow(
                            decoration: BoxDecoration(

                            ),
                            children: [
                              TableCell(
                                child: Center(
                                  child: Text(
                                    row.rank.toString(),
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                  ),
                                )
                              ),
                              TableCell(
                                child: SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      Image(image: NetworkImage(row.teamLogoUrl.toString()), width: 30, height: 30,),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          row.teamName,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    row.played.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    row.wins.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    row.points.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
