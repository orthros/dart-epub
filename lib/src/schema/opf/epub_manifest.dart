import 'package:quiver/collection.dart' as collections;

import 'epub_manifest_item.dart';

class EpubManifest {
  List<EpubManifestItem> Items;

  @override
  int get hashCode => Items.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubManifest;
    if (otherAs == null) {
      return false;
    }
    return collections.listsEqual(Items, otherAs.Items);
  }
}
