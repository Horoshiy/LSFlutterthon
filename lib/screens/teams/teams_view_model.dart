import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import 'package:SportRadar/actions/actions.dart';
import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/selectors/selectors.dart';

class TeamsViewModel {
  final SelectedWidget selectedWidget;
  final Function(WidgetName) onSetSelectedWidget;

  TeamsViewModel({@required this.selectedWidget, @required this.onSetSelectedWidget});

  static TeamsViewModel fromStore(Store<AppState> store) {
    return TeamsViewModel(
      selectedWidget: selectedWidgetSelector(store.state.selectedWidget),
      onSetSelectedWidget: (WidgetName widgetName) {
        store.dispatch(SetSelectedWidget(widgetName));
      },
    );
  }
}