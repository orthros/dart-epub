import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_content_file.dart';

class EpubByteContentFile extends EpubContentFile {
  List<int> Content;

  @override
  int get hashCode => hash4(Content.hashCode, ContentMimeType.hashCode,
      ContentType.hashCode, FileName.hashCode);

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
