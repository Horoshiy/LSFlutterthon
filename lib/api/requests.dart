import 'network.dart';
import 'package:SportRadar/utils/dateTime.dart';

const String baseURL = 'https://api.sportradar.us/soccer-';
const String accessLevel = 't';
const String version = '3';
const String leagueGroup = 'eu';
const String languageCode = 'en';
const String format = 'json';
const String apiKey = 'k7wdwngyc7e9d485wus9zg5a';

class Requests {

  Future<dynamic> getDailyResults(DateTime date) async {
    final String selectedDate = DateUtil.dateTimeToStringFormatter(date);
    Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/schedules/$selectedDate/results.$format?api_key=$apiKey');
    var sportMatchesData = await network.getData();
    return sportMatchesData;
  }

  Future<dynamic> getTeamStatistics(String seasonId, String teamId) async {
    Network network = Network('$baseURL$accessLevel$version/$leagueGroup/$languageCode/tournaments/$seasonId/teams/$teamId/statistics.$format?api_key=$apiKey');
    var seasonGoalsData = await network.getData();
    return seasonGoalsData;
  }
}