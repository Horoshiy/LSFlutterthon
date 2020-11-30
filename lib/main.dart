import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/reducers/app_reducer.dart';
import 'package:SportRadar/screens/teams/teams_controller.dart';

Future<void> main() async {
  const initialState = AppState(
    selectedWidget: SelectedWidget(
      name: WidgetName.averageGoalsWidget,
    ),
  );
  final store = Store<AppState>(
    appReducer,
    initialState: initialState,
  );
  runZonedGuarded<void>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(StoreProvider(store: store, child: SportRadar()));
    },
    (error, stackTrace) async {
      print('\n${error.toString()}\n${stackTrace.toString()}');
    },
  );
}

class SportRadar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer teams',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
      ),
      home: const Teams(title: 'Soccer teams'),
    );
  }
}

class Palette {
  static const Color primary = Color(0xff006a4a);
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);