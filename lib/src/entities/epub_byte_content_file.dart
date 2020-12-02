import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_content_file.dart';

class EpubByteContentFile extends EpubContentFile {
  List<int> Content;

  @override
  int get hashCode {
    var objects = []
      ..add(ContentMimeType.hashCode)
      ..add(ContentType.hashCode)
      ..add(FileName.hashCode)
      ..addAll(Content?.map((content) => content.hashCode) ?? [0]);
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubByteContentFile;
    if (otherAs == null) {
      return false;
    }
    return collections.listsEqual(Content, otherAs.Content) &&
        ContentMimeType == otherAs.ContentMimeType &&
        ContentType == otherAs.ContentType &&
        FileName == otherAs.FileName;
  }
}
