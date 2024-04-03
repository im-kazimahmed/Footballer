import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/screens/statistics/match_statistics.dart';

import '../api/football_api.dart';
import '../constants.dart';
import '../languages.dart';
import '../models/match.dart';

class TodayMatches extends StatelessWidget {
  final DateTime selectedDate;
  const TodayMatches({Key key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FutureBuilder(
                future: FootballApi.getMatchesByDate(
                  date: DateFormat('y-MM-d').format(selectedDate),
                ),
                // future: null,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(AppLocale.error.getString(context)),);
                  }

                  List<SoccerMatch> liveMatches = snapshot.data;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: COLOR_BLACK)
                              ),
                              child: Icon(Icons.arrow_back),
                            ),
                          ),
                          Text(
                            selectedDate.day == DateTime.now().day ?
                            AppLocale.todayMatch.getString(context):
                            "${DateFormat('d MMM').format(selectedDate)}'s ${AppLocale.match.getString(context)}",
                            style: TextStyle(
                              fontSize: fontSizeLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20,)
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: liveMatches.length-1,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            int timestamp = liveMatches[index].fixture.timestamp;
                            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                            String matchTime = DateFormat('h:mm').format(dateTime);
                            String currentTime = DateFormat('h:mm').format(DateTime.now().toLocal());

                            matchTime = matchTime.length == 4 ? "0$matchTime" : matchTime;
                            currentTime = currentTime.length == 4 ? "0$currentTime" : currentTime;

                            DateTime dt1 = DateTime.parse("2000-01-01 $matchTime:00");
                            DateTime dt2 = DateTime.parse("2000-01-01 $currentTime:00");

                            TimeOfDay t1 = TimeOfDay.fromDateTime(dt1);
                            TimeOfDay t2 = TimeOfDay.fromDateTime(dt2);

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: COLOR_WHITE,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  liveMatches[index].home.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  imageUrl: liveMatches[index].home.logoUrl,
                                                  placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 30,),
                                            Container(
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                color: COLOR_GREY.withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Text(matchTime,
                                                style: TextStyle(color: Colors.green),
                                              ),
                                            ),
                                            SizedBox(width: 30,),
                                            Row(
                                              children: [
                                                Text(
                                                  liveMatches[index].away.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  imageUrl: liveMatches[index].away.logoUrl,
                                                  placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 80,
                                  left: 120,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (builder) => MatchStatistics(
                                            match: liveMatches[index],
                                            isLive: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: COLOR_WHITE,
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      padding: EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
                                          if (t1.hour > t2.hour || (t1.hour == t2.hour && t1.minute > t2.minute))
                                            Text(AppLocale.toBePlayed.getString(context),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: COLOR_BLACK.withOpacity(0.5),
                                              ),
                                            )
                                          else
                                            Text(AppLocale.watchNow.getString(context),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: COLOR_BLACK.withOpacity(0.5),
                                              ),
                                            ),
                                          SizedBox(width: 10),
                                          Icon(Icons.stream)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 170,),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
