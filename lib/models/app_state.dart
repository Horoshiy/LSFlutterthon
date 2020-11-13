import 'package:meta/meta.dart';

import 'package:SportRadar/models/models.dart';

@immutable
class AppState {
  const AppState({
    @required this.selectedWidget,
  });
  
  final SelectedWidget selectedWidget;

  @override
  String toString() {
    return 'AppState: {reduxSetup: $selectedWidget}';
  }
}