import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_label.dart';
import 'epub_navigation_target.dart';

class EpubNavigationList {
  String Id;
  String Class;
  List<EpubNavigationLabel> NavigationLabels;
  List<EpubNavigationTarget> NavigationTargets;

  @override
  int get hashCode => hash4(Id.hashCode, Class.hashCode,
      NavigationLabels.hashCode, NavigationTargets.hashCode);

  bool operator ==(other) {
    var otherAs = other as EpubNavigationList;
    if (otherAs == null) return false;

    if (!(Id == otherAs.Id && Class == otherAs.Class)) {
      return false;
    }

    if (!collections.listsEqual(NavigationLabels, otherAs.NavigationLabels)) {
      return false;
    }
    if (!collections.listsEqual(NavigationTargets, otherAs.NavigationTargets)) {
      return false;
    }
    return true;
  }
}
