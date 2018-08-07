import 'package:quiver/collection.dart' as collections;

import 'epub_navigation_point.dart';

class EpubNavigationMap {
  List<EpubNavigationPoint> Points;

  @override
  int get hashCode => Points.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationMap;
    if (otherAs == null) return false;

    return collections.listsEqual(Points, otherAs.Points);
  }
}
