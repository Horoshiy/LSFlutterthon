import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:SportRadar/api/requests.dart';
import 'package:SportRadar/models/api/daily_results.dart';
import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/screens/sport_widgets/average_goals.dart';
import 'package:SportRadar/screens/teams/teams_view_model.dart';
import 'package:SportRadar/utils/dateTime.dart';
import 'package:SportRadar/widgets/progress_loader.dart';

class Teams extends StatefulWidget {
  Teams({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {

  Data _dailyResults;
  List<DailyResults> _filteredDailyResults;
  int _showMatchesByCountryIndex;
  bool _showSearchbar = false;
  DateTime _selectedDate = DateUtil.stringToDateFormatter('2020-11-02');

  Future _sportMatchesRequest() async {
    final result = await Requests().getDailyResults(_selectedDate);
    final data = json.decode(result);
    return data;
  }

  @override
  void initState() {
    _getSportMatchesData();
    super.initState();
  }

  void _getSportMatchesData() {
    _sportMatchesRequest().then((value) {
      setState(() {
        _dailyResults = Data.fromJson(value);
        _filteredDailyResults = _dailyResults.results;
      });
    });
  }

  void _onPressSearchIcon() {
    setState(() {
      _showSearchbar = !_showSearchbar;
      _filteredDailyResults = _dailyResults.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TeamsViewModel>(
      converter: (Store<AppState> store) => TeamsViewModel.fromStore(store),
      builder: (BuildContext context, TeamsViewModel teamsVM) { 
        return Scaffold(
          drawer: _drawer(teamsVM),
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 10.0, 16.0),
                child: GestureDetector(
                  onTap: () {
                    _onPressSearchIcon();
                  },
                  child: Icon(
                    Icons.search
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 16.0),
                child: GestureDetector(
                  onTap: () {
                    _buildMaterialDatePicker(context);
                  },
                  child: Icon(
                    Icons.calendar_today
                  ),
                )
              ),
            ],
          ),
          body: _dailyResults == null ? ProgressLoader() : Column(
            children: [
              if (_showSearchbar) _searchBar(),
              _dailyResultsList(teamsVM.selectedWidget),
            ],
          ),
        );
      },
    );
  }

  void _buildMaterialDatePicker(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2018),
      lastDate: DateTime(2021),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      },);
      // Make request when date changes
      _getSportMatchesData();
    }
  }

  Widget _drawer(TeamsViewModel teamsVM) {
    return Container (
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Widget',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,

            ),
          ),
          for (WidgetName widgetName in WidgetName.values) _drawerItem(widgetName, teamsVM),
        ],
      ),
    );
  }

  Widget _drawerItem(WidgetName widgetName, TeamsViewModel teamsVM) {
    WidgetName selectedWidgetName = teamsVM.selectedWidget.name;
    return ListTile(
      title: Container(
        color: selectedWidgetName == widgetName ? Colors.black12 : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widgetName.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20.0
            ),
          ),
        ),
      ),
      onTap: () {
        teamsVM.onSetSelectedWidget(widgetName);
        Navigator.pop(context);
      },
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Введите для поиска",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  setState(() {
                    _filteredDailyResults = _dailyResults.results.where((dailyResult) {
                      String teamTitle = dailyResult.sportEvent.tournament.name.toLowerCase();
                      return teamTitle.contains(text);
                    }).toList();
                  });
                },
              ),
            ),
          ]
        ),
    );
  }

  Widget _dailyResultsList(SelectedWidget selectedWidget) {
    return Expanded(
      child: ListView.builder(
        itemCount: (_filteredDailyResults == null || _filteredDailyResults.length == 0) ? 0 : _filteredDailyResults.length,
        itemBuilder: (BuildContext context, int index) {
          return _dailyResultItem(selectedWidget, _filteredDailyResults[index], index);
        }
      )
    );
  }

  Widget _dailyResultItem(SelectedWidget selectedWidget, DailyResults dailyResult, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                dailyResult.sportEvent.tournament.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0
                ),
              ),
              onTap: () {
                setState(() {
                  _showMatchesByCountryIndex = _showMatchesByCountryIndex == index ? null : index;
                });
              },
            ),
            _showMatchesByCountryIndex == index
              ? _teams(selectedWidget, dailyResult)
              : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _teams(SelectedWidget selectedWidget, DailyResults dailyResult) {
    final teamOne = dailyResult.sportEvent.competitors[0];
    final teamTwo = dailyResult.sportEvent.competitors[1];
    final periodScores = dailyResult.sportEventStatus.periodScores;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Row (
              children: [ 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamOne.name,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          // fontWeight: winner == 'home' ? FontWeight.w900 : FontWeight.w400
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        teamTwo.name,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            // fontWeight: winner == 'away' ? FontWeight.w900 : FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
                periodScores.isNotEmpty ? Row(
                  children:[
                    for (PeriodScores periodScore in periodScores) _periodScoreItem(periodScore),
                  ],
                ): SizedBox.shrink(),
              ],
            ),
            onTap: () {
              _navigateToSportWidget(context, dailyResult, selectedWidget);
            },
          ),
        ],
      ),
    );
  }

  Widget _periodScoreItem(PeriodScores periodScore) {
    return Row(
      children: [
        SizedBox(width: 6.0),
        Column(
          children: [
            Text(
              periodScore.homeScore.toString(),
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              periodScore.awayScore.toString(),
              style: TextStyle(
                  color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToSportWidget(BuildContext context, DailyResults dailyResult, SelectedWidget selectedWidget) {
    switch (selectedWidget.name) {
      case WidgetName.averageGoalsWidget:
        _navigateToAverageGoals(context, dailyResult);
        break;
      default: break;
    }
  }

  void _navigateToAverageGoals(BuildContext context, DailyResults dailyResult) {
    final seasonId = dailyResult.sportEvent.season.id;
    final teamOne = dailyResult.sportEvent.competitors[0];
    final teamTwo = dailyResult.sportEvent.competitors[1];
    if (seasonId != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AverageGoalsChart(
          seasonId: seasonId,
          teamOneId: teamOne.id,
          teamTwoId: teamTwo.id,
        ),),
      );
    }
  }

}
