import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import 'package:SportRadar/actions/actions.dart';
import 'package:SportRadar/models/models.dart';
import 'package:SportRadar/selectors/selectors.dart';

class TeamsViewModel {
  TeamsViewModel({@required this.selectedWidget, @required this.onSetSelectedWidget});

  final SelectedWidget selectedWidget;
  final Function(WidgetName) onSetSelectedWidget;

  static TeamsViewModel fromStore(Store<AppState> store) {
    return TeamsViewModel(
      selectedWidget: selectedWidgetSelector(store.state.selectedWidget),
      onSetSelectedWidget: (WidgetName widgetName) {
        store.dispatch(SetSelectedWidget(widgetName));
      },
    );
  }
}