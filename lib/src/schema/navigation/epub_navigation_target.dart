import 'epubMetadata.dart';
import 'epubNavigationLabel.dart';

class EpubNavigationTarget {
    String Id;
    String Class;
    String Value;
    String PlayOrder;
    List<EpubNavigationLabel> NavigationLabels;
    EpubNavigationContent Content;
}