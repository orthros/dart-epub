import 'package:quiver/collection.dart' as collections;

class EpubNavigationDocTitle {
  List<String> Titles;

  @override
  int get hashCode => Titles.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocTitle;
    if (otherAs == null) return false;

    return collections.listsEqual(Titles, otherAs.Titles);
  }
}
