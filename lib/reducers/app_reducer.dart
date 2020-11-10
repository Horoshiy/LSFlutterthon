import 'package:SportRadar/models/models.dart';

import 'sport_widget_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    selectedWidget: sportWidgetReducer(state.selectedWidget, action),
  );
}