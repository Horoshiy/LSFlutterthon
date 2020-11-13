import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/reducers/sport_widget_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    selectedWidget: sportWidgetReducer(state.selectedWidget, action),
  );
}