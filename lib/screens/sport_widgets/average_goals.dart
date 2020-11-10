import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:SportRadar/api/requests.dart';
import 'package:SportRadar/models/api/team_statistics.dart';
import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/widgets/progress_loader.dart';

class AverageGoalsChart extends StatefulWidget {
  //
  AverageGoalsChart({Key key, @required this.seasonId, this.teamOneId, this.teamTwoId}) : super(key: key);

  final String seasonId;
  final String teamOneId;
  final String teamTwoId;
  final String title = "Average goals";
 
  @override
  AverageGoalsChartState createState() => AverageGoalsChartState();
}
 
class AverageGoalsChartState extends State<AverageGoalsChart> {

  final timeintervalsArray = <String>["15'", "30'", "45'", "60'", "75'", "90'"];

  Team _teamOne;
  Team _teamTwo;
  Scored _teamOneScoredGoals;
  Scored _teamTwoScoredGoals;
  List<charts.Series> _seriesList;

  @override
  void initState()  {
    _seasonGoalsRequest(widget.teamOneId)
    .then((teamOneValue) {
      _seasonGoalsRequest(widget.teamTwoId)
      .then((teamTwoValue) {
        Data teamOneData = Data.fromJson(teamOneValue);
        Data teamTwoData = Data.fromJson(teamTwoValue);
        setState(() {
          _teamOne = teamOneData.team;
          _teamTwo = teamTwoData.team;
          _teamOneScoredGoals = teamOneData.goaltimeStatistics.scored;
          _teamTwoScoredGoals = teamTwoData.goaltimeStatistics.scored;
          _seriesList = teamOneData.team?.name != null && teamTwoData.team?.name != null
          ? _createAverageGoalsChartData()
          : null;
        });
      });
    });
    super.initState();
  }

  Future _seasonGoalsRequest(String teamId) async {
    var result = await Requests().getTeamStatistics(widget.seasonId, teamId);
    var data = json.decode(result);
    return data;   
  }

  List<GoalsByInterval> _goalsByIntervalList(Scored teamGoals, int teamTotal) {
    int index = 0;
    var goalsByIntervalList = <GoalsByInterval>[];
    for(final String timeInterval in timeintervalsArray){
      goalsByIntervalList.add(GoalsByInterval(timeInterval, teamGoals.period[index].value / teamTotal));
      index++;
    }
    return goalsByIntervalList; 
  }

  charts.Series<GoalsByInterval, String> _buildChart(String name, List<GoalsByInterval> goalsByInterval, charts.Color color) {
    return charts.Series<GoalsByInterval, String>(
      id: name,
      domainFn: (GoalsByInterval goalsByInterval, _) => goalsByInterval.interval,
      measureFn: (GoalsByInterval goalsByInterval, _) => goalsByInterval.goals,
      data: goalsByInterval,
      colorFn: (GoalsByInterval goalsByInterval, _) {return color;},
    );
  }

  List<charts.Series<GoalsByInterval, String>> _createAverageGoalsChartData() {
    final int teamOneTotal = _teamOneScoredGoals.total == 0 ? 1 : _teamOneScoredGoals.total;
    final int teamTwoTotal = _teamTwoScoredGoals.total == 0 ? 1 : _teamTwoScoredGoals.total;
    final teamOneGoals = _goalsByIntervalList(_teamOneScoredGoals, teamOneTotal);
    final teamTwoGoals = _goalsByIntervalList(_teamTwoScoredGoals, teamTwoTotal);
    final charts.Color orangeColor = charts.MaterialPalette.deepOrange.shadeDefault.lighter;
    final charts.Color blueColor = charts.MaterialPalette.blue.shadeDefault.lighter;
    return [
      _buildChart(_teamOne.name, teamOneGoals, orangeColor),
      _buildChart(_teamTwo.name, teamTwoGoals, blueColor),
    ];
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _seriesList != null ? _ordinalComboChart() : ProgressLoader(),
      ),
    );
  }

  Widget _ordinalComboChart() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: charts.OrdinalComboChart(
        _seriesList,
        animate: true,
        primaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredMinTickCount: 4,
            desiredMaxTickCount: 6,
            dataIsInWholeNumbers: false,
          ),
          renderSpec: charts.GridlineRendererSpec(
            labelAnchor: charts.TickLabelAnchor.centered,
            labelJustification: charts.TickLabelJustification.outside,
          ),
        ),
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped
        ),
        behaviors: [
          charts.ChartTitle('', // Used  for top padding
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 100
          ),
          charts.ChartTitle('Time interval',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea
          ),
          charts.SeriesLegend(
            position: charts.BehaviorPosition.inside,
            desiredMaxRows: 2,
            desiredMaxColumns: 1,
          ),
        ],
      ),
    );
  }
}



