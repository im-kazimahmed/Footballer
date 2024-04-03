import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/api/football_api.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/languages.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/screens/background.dart';
import 'package:footballer/screens/league_fixtures.dart';
import 'package:footballer/screens/league_teams.dart';
import 'package:footballer/screens/home/components/home_bottom.dart';
import 'package:footballer/screens/home/components/home_top.dart';
import 'package:footballer/screens/home/components/list_live_matches.dart';
import 'package:footballer/screens/today_matches.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../statistics/match_statistics.dart';

class Home extends StatefulWidget {
  static const route = 'home';
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  String selectedLanguage = 'English';
  String currentLanguageCode = 'en';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCurrentLanguage();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: COLOR_WHITE_LIGHT.withOpacity(0.9),
      body: SafeArea(
        child: Stack(
          children: [
            TransparentBackground(
              isHome: true,
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: size.height + 190,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        //app bar
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Footballer",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeXLarge,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(IMG_BALL, height: 30,),
                            SizedBox(width: 20),
                            DropdownButton<String>(
                              value: selectedLanguage,
                              onChanged: (String value) {
                                changeLanguage(value);
                              },
                              items: [
                                DropdownMenuItem(
                                  value: 'English',
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/flag_english.png', width: 30),
                                      SizedBox(width: 10),
                                      Text('English'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Somali',
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/flag_somali.png', width: 30),
                                      SizedBox(width: 10),
                                      Text('Somali'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: marginLarge,),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,),
                          SizedBox(width: 5),
                          Text(
                            DateFormat('MMM d,y').format(_selectedDate),
                            style: TextStyle(
                              fontSize: 20,
                              color: COLOR_BLACK.withOpacity(0.7),
                            ),
                          ),
                        ]
                      ),
                      SizedBox(
                        height: marginLarge,
                      ),
                      Container(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 365 + 12,
                          itemBuilder: (context, index) {
                            final date = DateTime.now().add(Duration(days: index));
                            if (date.year != DateTime.now().year && date.month != DateTime.now().month) {
                              return SizedBox.shrink();
                            }
                            // print(DateFormat('y-MM-d').format(date));
                            return CalendarDay(
                              date: date,
                              selectedDate: DateFormat('y-MM-d').format(_selectedDate),
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: marginLarge,
                      ),
                      if(_selectedDate.day == DateTime.now().day)
                        Expanded(
                        child: FutureBuilder(
                          // future: FootballApi.getMatchesByDate(date: DateFormat('y-mm-d').format(_selectedDate)),
                          future: FootballApi.getLiveMatches(),
                          // future: null,
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

                            // liveMatches = snapshot.data;
                            List<SoccerMatch> liveMatches = snapshot.data;
                            return LiveMatchesList(
                              limit: 1,
                              liveMatches: liveMatches,
                            );
                          },
                        ),
                      ),
                      // SizedBox(height: marginLarge,),
                      FutureBuilder(
                        future: FootballApi.getMatchesByDate(
                          date: DateFormat('y-MM-d').format(_selectedDate),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TodayMatches(selectedDate: _selectedDate,)));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/images/premier-league.png", height: 40,),
                                        SizedBox(width: 10,),
                                        Text(
                                          _selectedDate.day == DateTime.now().day ?
                                          AppLocale.todayMatch.getString(context):
                                          "${DateFormat('d MMM').format(_selectedDate)} ${AppLocale.match.getString(context)}",
                                          style: TextStyle(
                                            fontSize: fontSizeLarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _selectedDate.day == DateTime.now().day ? 400: size.height,
                                child: ListView.builder(
                                  itemCount: _selectedDate.day == DateTime.now().day ? 2: liveMatches.length-1,
                                  physics: _selectedDate.day == DateTime.now().day ?
                                    NeverScrollableScrollPhysics(): AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, indexListView) {
                                    int index = indexListView + 1;
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language_code') ?? 'en';
    String currentLanguage = prefs.getString('currentLanguage') ?? 'English';
    log("language code: $languageCode");
    log("language: $currentLanguage");
    setState(() {
      selectedLanguage = currentLanguage;
      currentLanguageCode = languageCode;
    });
  }

  void changeLanguage(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', newValue == "Somali" ? 'so': 'en');
    prefs.setString('currentLanguage', newValue.toString());

    setState(() {
      selectedLanguage = newValue;
      newValue == "English" ? _localization.translate('en'):_localization.translate('so');
    });
  }
}

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final String selectedDate;
  final void Function(DateTime date) onDateSelected;

  CalendarDay({
    @required this.date,
    @required this.selectedDate,
    @required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(date);
    final dayNumber = DateFormat('d').format(date);
    final currentDate = DateFormat('y-MM-d').format(date);

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedDate == currentDate ? COLOR_BLUE : Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: selectedDate == currentDate ? COLOR_WHITE : COLOR_BLACK.withOpacity(0.4),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: 18,
                    color: selectedDate == currentDate ? COLOR_WHITE : COLOR_BLACK,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}