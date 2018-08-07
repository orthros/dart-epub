import 'package:quiver/core.dart';

import 'epub_content_file.dart';

class EpubTextContentFile extends EpubContentFile {
  String Content;

  @override
  int get hashCode => hash4(Content, ContentMimeType, ContentType, FileName);

  bool operator ==(other) {
    var otherAs = other as EpubTextContentFile;
    if (otherAs == null) {
      return false;
    }
    return Content == otherAs.Content &&
        ContentMimeType == otherAs.ContentMimeType &&
        ContentType == otherAs.ContentType &&
        FileName == otherAs.FileName;
  }
}
