import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footballer/models/lineups_model.dart';
import 'package:footballer/models/substitutes_model.dart';
import 'package:footballer/models/team.dart';
import 'package:graphview/GraphView.dart';

import '../../api/football_api.dart';
import '../../constants.dart';
import '../../models/match.dart';
import '../../models/players_statistics.dart';

class LineUps extends StatefulWidget {
  final SoccerMatch match;
  const LineUps({Key key, this.match}) : super(key: key);

  @override
  _LineUpsState createState() => _LineUpsState();
}

class _LineUpsState extends State<LineUps> {
  List<SubstitutesModel> homeLineups;
  List<SubstitutesModel> awayLineups;
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
    homeLineups = await FootballApi.getTeamLineUps(
        widget.match.home.id, widget.match.fixture.id);

    homeLineups.sort((a, b) => a.number.compareTo(b.number));

    awayLineups = await FootballApi.getTeamLineUps(
        widget.match.away.id, widget.match.fixture.id);

    awayLineups.sort((a, b) => a.number.compareTo(b.number));


    // print(homeLineups[0].team.name);
    // print(homeLineups[0].substitutes);
    // print(awayLineups)

    isLoading = false;
    _homeLineUpLength = homeLineups.length;
    _awayLineUpLength = awayLineups.length;
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
    _homeLineUpLength >= _awayLineUpLength ? _awayLineUpLength : _homeLineUpLength;
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
          _statLength >0 ? Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: _size.height + 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(widget.match.home.logoUrl.toString(), height: 40,),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                Text(
                                  widget.match.home.name.toString(),
                                ),
                                // Text(homeLineups[index].team.country.toString())
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.network(widget.match.away.logoUrl.toString(), height: 40,),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                Text(
                                  widget.match.away.name.toString(),
                                ),
                                // Text(awayLineups[index].team.country.toString())
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/lineups.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Lineups",
                      style: TextStyle(
                          color: COLOR_GREY_LIGHT,
                          fontSize: fontSizeStandard
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _homeLineUpLength,
                        physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //// Home Lineups
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${homeLineups[index].number}.${homeLineups[index].name.substring(1)}"),
                                      Text(
                                        "${homeLineups[index].name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSizeStandard
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                  //// Away Lineups
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("${awayLineups[index].number}.${awayLineups[index].name.substring(1)}"),
                                      Text(
                                        "${awayLineups[index].name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSizeStandard
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  )
                                ],
                              )
                            ],
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),
          ): Center(child: Text("No lineups available right now"),)
      ],
    );
  }
}
