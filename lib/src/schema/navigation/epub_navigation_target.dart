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
  int get hashCode => hashObjects([
        Id.hashCode,
        Class.hashCode,
        Value.hashCode,
        PlayOrder.hashCode,
        NavigationLabels.hashCode,
        Content.hashCode
      ]);

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
