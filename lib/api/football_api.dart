import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:footballer/models/lineups_model.dart';
import 'package:footballer/models/match.dart';
import 'package:footballer/models/players_statistics.dart';
import 'package:footballer/models/standings_model.dart';
import 'package:footballer/models/statistic.dart';
import 'package:footballer/models/substitutes_model.dart';
import 'package:footballer/models/team_info.dart';

import '../models/h2h_model.dart';

class FootballApi {
  static const baseUrl = "https://api-football-v1.p.rapidapi.com/v3/";

  static const kHeaders = {
    'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
    'x-rapidapi-key': "62b1d4f3c5mshea37ed8df080c5fp1b63c7jsnb218a3066904"
  };

  static final _dio = Dio();

  static Future<List<SoccerMatch>> getLeagueMatches(
      int season, int leagueId) async {
    // final url = Uri.parse(baseUrl +
    //     "fixtures?season=${season.toString()}&league=${leagueId.toString()}");
    // Response res = await get(url, headers: headers);

    final url = baseUrl +"fixtures?season=${season.toString()}&league=${leagueId.toString()}";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    List<SoccerMatch> matches = [];

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> matchesList = body['response'];
      print("getLeagueMatches: $body");
      matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();
    }
    return matches;
  }

  static Future<List<SoccerMatch>> getMatchesByDate({String date}) async {
    // final url = Uri.parse(baseUrl + "fixtures?live=all");
    // Response res = await get(url, headers: headers);
    List<SoccerMatch> matches = [];

    final url = baseUrl + "fixtures?date=${date}";
    // final url = "https://kazimahmed.com/api/liveFixtures.txt";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(minutes: 2),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> matchesList = body['response'];
      matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();
    }
    return matches;
  }

  static Future<List<SoccerMatch>> getLiveMatches() async {
    // final url = Uri.parse(baseUrl + "fixtures?live=all");
    // Response res = await get(url, headers: headers);
    List<SoccerMatch> matches = [];

    final url = baseUrl + "fixtures?live=all";
    // final url = "https://kazimahmed.com/api/liveFixtures.txt";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> matchesList = body['response'];
      matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();
    }
    return matches;
  }

  static Future<List<Statistic>> getTeamStatistics(
      int fixtureId, int teamId) async {
    print("[Footballer] :: getting team statistics for team $teamId.. fixtureId $fixtureId");
    // final url = Uri.parse(baseUrl +
    //     "fixtures/statistics?fixture=${fixtureId.toString()}&team=${teamId.toString()}");
    // Response res = await get(url, headers: headers).catchError((error) {
    //   print(error);
    // });

    List<Statistic> statistics = [];

    final url = baseUrl + "fixtures/statistics?fixture=${fixtureId.toString()}&team=${teamId.toString()}";
    // final url = "https://kazimahmed.com/api/statistics.txt";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);

      // List<dynamic> matchesList = body['response'];
      // statistics = matchesList
      //     .map((dynamic item) => Statistic.fromJson(item))
      //     .toList();


      List<dynamic> response = body['response'];

      if(response.length>0){
        for (Map<String, dynamic> stat in response.first['statistics']) {
          // print("loop :: ${stat.toString()}");
          try {
            statistics.add(Statistic.fromJson(stat));
          } catch (e) {
            print(e);
          }
        }
      } else {
        print("response is null");
      }
      print("stats:: ${statistics.toList()}");
    }
    return statistics;
  }

  static Future<List<PlayersStatistics>> getPlayersStatistics(
      int fixtureId) async {
    print("[Footballer] :: getting players statistics for fixtureId $fixtureId");

    List<PlayersStatistics> statistics = [];

    final url = baseUrl + "fixtures/players?fixture=${fixtureId.toString()}}";
    // final url = "https://kazimahmed.com/api/playersStatisticsByFixtureId.txt";


    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> response = body['response'];

      if(response.length>0){
        for (Map<String, dynamic> stat in response.first['players']) {
          try {
            statistics.add(PlayersStatistics.fromJson(stat));
          } catch (e) {
            print(e);
          }
        }
      } else {
        print("response is null");
      }
      // for (Map<String, dynamic> stat in response.first['statistics']) {
      //   try {
      //     statistics.last.statistics = Statistic.fromJson(stat);
      //     // statistics.add(Statistic.fromJson(stat));
      //   } catch (e) {
      //     print(e);
      //   }
      // }
    }
    return statistics;
  }

  static Future<List<SubstitutesModel>> getTeamLineUps(
      int teamId, int fixtureId) async {
    print("[Footballer] :: getting fixture lineups for fixtureId $fixtureId, team:$teamId");

    List<SubstitutesModel> statistics = [];

    final url = baseUrl + "fixtures/lineups?fixture=${fixtureId.toString()}&team=${teamId.toString()}";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> response = body['response'];

      if(response.length>0){
        for (Map<String, dynamic> stat in response.first["startXI"]) {
          try {
            statistics.add(SubstitutesModel.fromJson(stat));
          } catch (e) {
            print(e);
          }
        }
      } else {
        print("response is null");
      }

    }
    return statistics;
  }

  static Future<List<HeadToHeadModel>> getH2HData(
      {int teamHomeId, int teamAwayId}) async {
    print("[Footballer] :: getting fixture Head to head matches for team:$teamHomeId, team:$teamAwayId");

    final url = baseUrl + "fixtures/headtohead?h2h=$teamHomeId-$teamAwayId";
    // final url = "https://kazimahmed.com/api/h2h.txt";
    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.data);
      List<dynamic> response = body['response'];
      List<HeadToHeadModel> h2hList = response.map((json) => HeadToHeadModel.fromJson(json)).toList();
      return h2hList;
    } else {
      throw Exception('Failed to load h2h data');
    }
  }


  static Future<List<StandingsModel>> getLeagueStandings(
      {int leagueId, int season}) async {
    print("[Footballer] :: getting league standings for league $leagueId, season:$season");

    final url = baseUrl + "standings?season=$season&league=$leagueId";
    // final url = "https://kazimahmed.com/api/standings.txt";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(seconds: 30),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.data);
      List<dynamic> response = body['response'][0]['league']['standings'][0];

      List<StandingsModel> standings = response.map((json) => StandingsModel.fromJson(json)).toList();
      return standings;
    } else {
      throw Exception('Failed to load standings data');
    }
  }

  // static Future<List<StandingsModel>> getLeagueStandings(
  //     {int leagueId}) async {
  //   final url = "https://kazimahmed.com/api/standings.txt";
  //   Response<String> res = await _dio.get(
  //     url,
  //     options: buildCacheOptions(
  //       Duration(seconds: 30),
  //       options: Options(
  //         headers: kHeaders,
  //       ),
  //     ),
  //   );
  //   if (res.statusCode == 200) {
  //     var body = jsonDecode(res.data);
  //     List<dynamic> response = body['response'];
  //
  //     List<StandingsModel> standings = response.map((json) => StandingsModel.fromJson(json)).toList();
  //     return standings;
  //   } else {
  //     throw Exception('Failed to load standings data');
  //   }
  // }

  static Future<List<TeamInfo>> getLeagueTeams(int leagueId, int season) async {
    print("[Footballer] :: getLeagueTeams: called");
    // final url = Uri.parse(baseUrl + "teams?league=$leagueId&season=$season");

    // Response res = await get(url, headers: headers).catchError((error) {
    //   print(error);
    // });

    final url = baseUrl + "teams?league=$leagueId&season=$season";

    Response<String> res = await _dio.get(
      url,
      options: buildCacheOptions(
        Duration(days: 2),
        options: Options(
          headers: kHeaders,
        ),
      ),
    );

    print("url:: $url");
    List<TeamInfo> teams = [];

    if (res.statusCode == 200) {

      _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: url)).interceptor,
      );

      var body = jsonDecode(res.data);
      List<dynamic> teamsList = body['response'];
      try {
        teams =
            teamsList.map((dynamic item) => TeamInfo.fromJson(item)).toList();
      } catch (error) {
        print(error);
      }
      print("teams:: ${teams.toList()}");
    }
    return teams;
  }
}
