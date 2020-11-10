import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class AppState {

  final SelectedWidget selectedWidget;

    const AppState({
      @required this.selectedWidget,
    });

  @override
  String toString() {
    return 'AppState: {reduxSetup: $selectedWidget}';
  }
}