import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocAuthor {
  List<String> Authors;

  EpubNavigationDocAuthor() {
    Authors = List<String>();
  }

  @override
  int get hashCode {
    var objects = []..addAll(Authors.map((author) => author.hashCode));
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocAuthor;
    if (otherAs == null) return false;

    return collections.listsEqual(Authors, otherAs.Authors);
  }
}
