import 'epub_metadata.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  String Id;
  String Value;
  EpubNavigationPageTargetType Type;
  String Class;
  String PlayOrder;
  List<EpubNavigationLabel> NavigationLabels;
  EpubNavigationContent Content;
}
