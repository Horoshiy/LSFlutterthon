import 'dart:async';
import 'dart:convert';

import 'package:SportRadar/api/requests.dart';
import 'package:SportRadar/models/api/team_statistics.dart';
import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/widgets/progress_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AverageGoalsChart extends StatefulWidget {
  AverageGoalsChart(
      {Key key,
      @required this.seasonId,
      this.teamOneId,
      this.teamTwoId,
      this.matchStatus,
      this.currentMatchTime})
      : super(key: key);

  final String seasonId;
  final String teamOneId;
  final String teamTwoId;
  final String matchStatus;
  final String currentMatchTime;
  String title = 'Average goals';

  @override
  AverageGoalsChartState createState() => AverageGoalsChartState();
}

class AverageGoalsChartState extends State<AverageGoalsChart> {
  final timeIntervalsArray = <int>[15, 30, 45, 60, 75, 90];

  Team _teamOne;
  Team _teamTwo;
  Scored _teamOneScoredGoals;
  Scored _teamOneConcededGoals;
  Scored _teamTwoScoredGoals;
  Scored _teamTwoConcededGoals;
  List<GoalsByInterval> _goalsByInterval;
  int _gameMinute;

  @override
  void initState() {
    _seasonGoalsRequest(widget.teamOneId).then((Data teamOneData) {
      _seasonGoalsRequest(widget.teamTwoId).then((Data teamTwoData) {
        setState(() {
          _teamOne = teamOneData.team;
          _teamTwo = teamTwoData.team;
          _gameMinute = int.parse(widget.currentMatchTime.split(':')[0]);
          _teamOneScoredGoals = teamOneData.goaltimeStatistics.scored;
          _teamOneConcededGoals = teamOneData.goaltimeStatistics.conceded;
          _teamTwoScoredGoals = teamTwoData.goaltimeStatistics.scored;
          _teamTwoConcededGoals = teamTwoData.goaltimeStatistics.conceded;
          _goalsByInterval =
              teamOneData.team?.name != null && teamTwoData.team?.name != null
                  ? _createCurrentAverageGoalsData()
                  : null;
        });
      });
    });
    super.initState();
  }

  Future<Data> _seasonGoalsRequest(String teamId) async {
    final dynamic result =
        await Requests().getTeamStatistics(widget.seasonId, teamId);
    final dynamic data = jsonDecode(result.toString());
    final Data teamData = Data.fromJson(data as Map<String, dynamic>);
    return teamData;
  }

  int getPeriodIndex() {
    if (_gameMinute < 15) {
      return 0;
    } else if (_gameMinute < 30) {
      return 1;
    } else if (_gameMinute <= 45) {
      return 2;
    } else if (_gameMinute < 60) {
      return 3;
    } else if (_gameMinute < 75) {
      return 4;
    } else if (_gameMinute <= 90) {
      return 5;
    } else {
      return 0;
    }
  }

  GoalsByInterval _goalsByMinuteList(Scored teamGoals, int teamTotal) {
    final int index = getPeriodIndex();
    return GoalsByInterval(
        timeIntervalsArray[index],
        double.parse((teamGoals.period[index].value / teamTotal * 100)
            .toStringAsFixed(2)));
  }

  List<GoalsByInterval> _createCurrentAverageGoalsData() {
    final int teamOneTotal =
        _teamOneScoredGoals.total == 0 ? 1 : _teamOneScoredGoals.total;
    final int teamOneConTotal =
        _teamOneConcededGoals.total == 0 ? 1 : _teamOneConcededGoals.total;
    final int teamTwoTotal =
        _teamTwoScoredGoals.total == 0 ? 1 : _teamTwoScoredGoals.total;
    final int teamTwoConTotal =
        _teamTwoConcededGoals.total == 0 ? 1 : _teamTwoConcededGoals.total;
    final teamOneGoals = _goalsByMinuteList(_teamOneScoredGoals, teamOneTotal);
    final teamOneConGoals =
        _goalsByMinuteList(_teamOneConcededGoals, teamOneConTotal);
    final teamTwoGoals = _goalsByMinuteList(_teamTwoScoredGoals, teamTwoTotal);
    final teamTwoConGoals =
        _goalsByMinuteList(_teamTwoConcededGoals, teamTwoConTotal);

    return [teamOneGoals, teamOneConGoals, teamTwoGoals, teamTwoConGoals];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _goalsByInterval != null
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$_gameMinute минута', style: const TextStyle(fontWeight: FontWeight.bold),),
                  Text(
                      'Статистика по голам с ${_goalsByInterval[0].interval - 15} по ${_goalsByInterval[0].interval} минуту',
                  style: const TextStyle(fontWeight: FontWeight.w900),),
                  Text('${_teamOne.name} забито ${_goalsByInterval[0].goals}%'),
                  Text(
                      '${_teamOne.name} пропущено ${_goalsByInterval[1].goals}%'),
                  Text('${_teamTwo.name} забито ${_goalsByInterval[2].goals}%'),
                  Text(
                      '${_teamTwo.name} пропущено ${_goalsByInterval[3].goals}%')
                ])
              : const ProgressLoader()),
    );
  }
}
