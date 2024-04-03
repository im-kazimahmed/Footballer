import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/api/football_api.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/league.dart';
import 'package:footballer/models/team_info.dart';
import 'package:footballer/screens/background.dart';
import 'package:footballer/widgets/item_team_info.dart';

class LeagueTeams extends StatefulWidget {
  static const ROUTE_NAME = "LeagueTeams";
  final League league;
  const LeagueTeams({Key key, @required this.league}) : super(key: key);

  @override
  _LeagueTeamsState createState() => _LeagueTeamsState();
}

class _LeagueTeamsState extends State<LeagueTeams> {
  int season = 2020;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _topPadding = MediaQuery.of(context).padding.top;
    print("League Id:: ${widget.league.id}");
    return Scaffold(
      body: Stack(
        children: [
          //background
          TransparentBackground(
            isHome: false,
          ),
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
                    Text("${AppLocale.season.getString(context)}:"),
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
                  future: FootballApi.getLeagueTeams(widget.league.id, season),
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
                        child: Text(AppLocale.noTeams.getString(context)),
                      );
                    }

                    final List<TeamInfo> teams = snapshot.data;
                    return ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (ctx, index) {
                        return TeamInfoItem(
                          // leagueId: widget.league.id,
                          teamInfo: teams[index],
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
