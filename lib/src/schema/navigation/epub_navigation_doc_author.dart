import 'package:quiver/collection.dart' as collections;

class EpubNavigationDocAuthor {
  List<String> Authors;

  @override
  int get hashCode => Authors.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocAuthor;
    if (otherAs == null) return false;

    return collections.listsEqual(Authors, otherAs.Authors);
  }
}
