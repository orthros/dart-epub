import 'epubMetadata.dart';
import 'epubNavigationLabel.dart';

class EpubNavigationPoint {
    String Id;
    String Class;
    String PlayOrder;
    List<EpubNavigationLabel> NavigationLabels;
    EpubNavigationContent Content;
    List<EpubNavigationPoint> ChildNavigationPoints;

    String toString()
    {
        return "Id: ${Id}, Content.Source: ${Content.Source}";
    }
}