import 'epubMetadata.dart';
import 'epubNavigationLabel.dart';
import 'epubNavigationPageTargetType.dart';

class EpubNavigationPageTarget {
    String Id;
    String Value;
    EpubNavigationPageTargetType Type;
    String Class;
    String PlayOrder;
    List<EpubNavigationLabel> NavigationLabels;
    EpubNavigationContent Content;
}