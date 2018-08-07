import 'package:quiver/collection.dart' as collections;

import 'epub_navigation_head_meta.dart';

class EpubNavigationHead {
  List<EpubNavigationHeadMeta> Metadata;

  @override
  int get hashCode => Metadata.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationHead;
    if (otherAs == null) {
      return false;
    }

    return collections.listsEqual(Metadata, otherAs.Metadata);
  }
}
