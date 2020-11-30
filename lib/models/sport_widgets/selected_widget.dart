import 'package:meta/meta.dart';

enum WidgetName { 
  averageGoalsWidget,
  liveGameWidget,
}

extension WidgetNameTitle on WidgetName {
  String get title {
    switch(this) {
      case WidgetName.averageGoalsWidget: return 'Average Goals';
      case WidgetName.liveGameWidget: return 'Live Game';
      default: return 'Live Game';
    }
  }
  
  static WidgetName getByName(String title) {
     switch(title) {
       case 'Average Goals': return WidgetName.averageGoalsWidget;
       case 'Vertical Time': return WidgetName.liveGameWidget;
       default: return WidgetName.liveGameWidget;
    }
  }
}

@immutable
class SelectedWidget {
  const SelectedWidget({
    @required this.name,
  });

  final WidgetName name;

  dynamic toJson() => {
    'name': name,
  };
}