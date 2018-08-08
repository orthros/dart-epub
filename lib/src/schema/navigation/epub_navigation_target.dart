import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationTarget {
  String Id;
  String Class;
  String Value;
  String PlayOrder;
  List<EpubNavigationLabel> NavigationLabels;
  EpubNavigationContent Content;

  @override
  int get hashCode {
    var objects = []
      ..add(Id.hashCode)
      ..add(Class.hashCode)
      ..add(Value.hashCode)
      ..add(PlayOrder.hashCode)
      ..add(Content.hashCode)
      ..addAll(NavigationLabels.map((label) => label.hashCode));
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubNavigationTarget;
    if (otherAs == null) return false;

    if (!(Id == otherAs.Id &&
        Class == otherAs.Class &&
        Value == otherAs.Value &&
        PlayOrder == otherAs.PlayOrder &&
        Content == otherAs.Content)) {
      return false;
    }

    return collections.listsEqual(NavigationLabels, otherAs.NavigationLabels);
  }
}
