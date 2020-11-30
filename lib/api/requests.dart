import 'package:SportRadar/api/network.dart';
import 'package:SportRadar/utils/datetime.dart';

const String baseURL = 'https://api.sportradar.us/soccer-';
const String accessLevel = 't';
const String version = '3';
const String leagueGroup = 'eu';
const String languageCode = 'en';
const String format = 'json';
const String apiKey = 'jfk8p2yq6n7d4vaaexs6ggsz';

class Requests {

  Future<dynamic> getLiveResults() async {
    final String selectedDate = DateUtil.dateTimeToStringFormatter(DateTime.now());
    final Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/schedules/live/results.$format?api_key=$apiKey');
    final dynamic sportMatchesData = await network.getData();
    return sportMatchesData;
  }

  Future<dynamic> getDailyResults(DateTime date) async {
    final String selectedDate = DateUtil.dateTimeToStringFormatter(date);
    final Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/schedules/$selectedDate/results.$format?api_key=$apiKey');
    final dynamic sportMatchesData = await network.getData();
    return sportMatchesData;
  }

  Future<dynamic> getTeamStatistics(String seasonId, String teamId) async {
    final Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/tournaments/$seasonId/teams/$teamId/statistics.$format?api_key=$apiKey');
    final dynamic seasonGoalsData = await network.getData();
    return seasonGoalsData;
  }

  Future<dynamic> getMatchTimeline(String matchId) async {
    final Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/matches/$matchId/timeline.$format?api_key=$apiKey');
    final dynamic matchTimeLine = await network.getData();
    return matchTimeLine;
  }
}