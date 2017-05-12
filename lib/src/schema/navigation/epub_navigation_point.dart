import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationPoint {
  String Id;
  String Class;
  String PlayOrder;
  List<EpubNavigationLabel> NavigationLabels;
  EpubNavigationContent Content;
  List<EpubNavigationPoint> ChildNavigationPoints;

  String toString() {
    return "Id: ${Id}, Content.Source: ${Content.Source}";
  }
}
