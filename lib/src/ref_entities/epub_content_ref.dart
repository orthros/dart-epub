import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  Map<String, EpubTextContentFileRef> Html;
  Map<String, EpubTextContentFileRef> Css;
  Map<String, EpubByteContentFileRef> Images;
  Map<String, EpubByteContentFileRef> Fonts;
  Map<String, EpubContentFileRef> AllFiles;

  @override
  int get hashCode => hashObjects([
        Html.hashCode,
        Css.hashCode,
        Images.hashCode,
        Fonts.hashCode,
        AllFiles.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubContentRef;
    if (otherAs == null) {
      return false;
    }

    return collections.mapsEqual(Html, otherAs.Html) &&
        collections.mapsEqual(Css, otherAs.Css) &&
        collections.mapsEqual(Images, otherAs.Images) &&
        collections.mapsEqual(Fonts, otherAs.Fonts) &&
        collections.mapsEqual(AllFiles, otherAs.AllFiles);
  }
}
