import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/api/football_api.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/league.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/screens/background.dart';
import 'package:footballer/screens/statistics/match_statistics.dart';
import 'package:footballer/widgets/item_match_fixture.dart';

class LeagueFixtures extends StatefulWidget {
  static const ROUTE_NAME = "LeagueFixtures";
  final League league;
  const LeagueFixtures({Key key, @required this.league}) : super(key: key);

  @override
  _LeagueFixturesState createState() => _LeagueFixturesState();
}

class _LeagueFixturesState extends State<LeagueFixtures> {
  int season = 2022;

  @override
  void initState() {
    // TODO: implement initState
    // season = DateTime.now().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          //background
          TransparentBackground(),
          //main column contains top header and list
          Column(
            children: [
              //top header container
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radiusStandard),
                  bottomRight: Radius.circular(radiusStandard),
                ),
                child: Container(
                  height: _size.height * 0.27,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          widget.league.cover,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                      ),
                      Positioned(
                        top: _topPadding,
                        left: marginLarge,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(marginStandard),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(AppLocale.season.getString(context)),
                    DropdownButton<int>(
                      hint: Text(season.toString()),
                      // dropdownColor:,
                      items: SEASONS.map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          season = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: FootballApi.getLeagueMatches(season, widget.league.id),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(AppLocale.error.getString(context)),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(AppLocale.noFixturesFound.getString(context)),
                      );
                    }

                    final List<SoccerMatch> leagueFixtures = snapshot.data;
                    return ListView.builder(
                      itemCount: leagueFixtures.length,
                      itemBuilder: (ctx, index) {
                        return MatchFixtureItem(
                          leagueId: widget.league.id,
                          match: leagueFixtures[index],
                          onFixtureTap: (match) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) => MatchStatistics(
                                  match: match,
                                  isLive: false,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
