import 'package:quiver/core.dart';

import 'epub_content_type.dart';

abstract class EpubContentFile {
  String FileName;
  EpubContentType ContentType;
  String ContentMimeType;

  @override
  int get hashCode =>
      hash3(FileName.hashCode, ContentType.hashCode, ContentMimeType.hashCode);

  bool operator ==(other) {
    var otherAs = other as EpubContentFile;
    if (otherAs == null) {
      return false;
    }
    return FileName == otherAs.FileName &&
        ContentType == otherAs.ContentType &&
        ContentMimeType == otherAs.ContentMimeType;
  }
}
