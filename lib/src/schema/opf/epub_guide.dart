import 'package:quiver/collection.dart' as collections;

import 'epub_guide_reference.dart';

class EpubGuide {
  List<EpubGuideReference> Items;

  @override
  int get hashCode => Items.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubGuide;
    if (otherAs == null) {
      return false;
    }

    return collections.listsEqual(Items, otherAs.Items);
  }
}
