import 'package:redux/redux.dart';

import 'package:SportRadar/actions/actions.dart';
import 'package:SportRadar/models/models.dart';

final sportWidgetReducer = TypedReducer<SelectedWidget, SetSelectedWidget>(_sportWidgetReducer);

SelectedWidget _sportWidgetReducer(SelectedWidget state, SetSelectedWidget action) {
  return SelectedWidget(name: action.name);
}