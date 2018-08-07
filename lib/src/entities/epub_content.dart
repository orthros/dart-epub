import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent {
  Map<String, EpubTextContentFile> Html;
  Map<String, EpubTextContentFile> Css;
  Map<String, EpubByteContentFile> Images;
  Map<String, EpubByteContentFile> Fonts;
  Map<String, EpubContentFile> AllFiles;

  @override
  int get hashCode => hashObjects([
        Html.hashCode,
        Css.hashCode,
        Images.hashCode,
        Fonts.hashCode,
        AllFiles.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubContent;
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
