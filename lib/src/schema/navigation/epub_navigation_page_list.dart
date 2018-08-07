import 'package:quiver/collection.dart' as collections;

import 'epub_navigation_page_target.dart';

class EpubNavigationPageList {
  List<EpubNavigationPageTarget> Targets;

  @override
  int get hashCode => Targets.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationPageList;
    if (otherAs == null) return false;

    return collections.listsEqual(Targets, otherAs.Targets);
  }
}
