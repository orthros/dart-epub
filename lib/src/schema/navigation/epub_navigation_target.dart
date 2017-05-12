import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationTarget {
  String Id;
  String Class;
  String Value;
  String PlayOrder;
  List<EpubNavigationLabel> NavigationLabels;
  EpubNavigationContent Content;
}
