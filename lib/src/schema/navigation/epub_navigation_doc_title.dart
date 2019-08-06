import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocTitle {
  List<String> Titles;

  EpubNavigationDocTitle() {
    Titles = List<String>();
  }

  @override
  int get hashCode {
    var objects = []..addAll(Titles.map((title) => title.hashCode));
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocTitle;
    if (otherAs == null) return false;

    return collections.listsEqual(Titles, otherAs.Titles);
  }
}
