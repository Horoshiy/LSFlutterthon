import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models/models.dart';
import 'reducers/app_reducer.dart';
import 'screens/teams/teams_controller.dart';

void main() {
  final initialState = AppState(
    selectedWidget: SelectedWidget(
      name: WidgetName.averageGoalsWidget,
    ),
  );
  final store = Store<AppState>(
    appReducer,
    initialState: initialState,
  );
  runApp(StoreProvider(store: store, child: SportRadar()));
}

class SportRadar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer teams',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Teams(title: 'Soccer teams'),
    );
  }
}
