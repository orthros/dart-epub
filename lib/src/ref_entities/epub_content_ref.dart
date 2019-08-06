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

  EpubContentRef() {
    Html = Map<String, EpubTextContentFileRef>();
    Css = Map<String, EpubTextContentFileRef>();
    Images = Map<String, EpubByteContentFileRef>();
    Fonts = Map<String, EpubByteContentFileRef>();
    AllFiles = Map<String, EpubContentFileRef>();
  }

  @override
  int get hashCode {
    var objects = []
      ..addAll(Html.keys.map((key) => key.hashCode))
      ..addAll(Html.values.map((value) => value.hashCode))
      ..addAll(Css.keys.map((key) => key.hashCode))
      ..addAll(Css.values.map((value) => value.hashCode))
      ..addAll(Images.keys.map((key) => key.hashCode))
      ..addAll(Images.values.map((value) => value.hashCode))
      ..addAll(Fonts.keys.map((key) => key.hashCode))
      ..addAll(Fonts.values.map((value) => value.hashCode))
      ..addAll(AllFiles.keys.map((key) => key.hashCode))
      ..addAll(AllFiles.values.map((value) => value.hashCode));

    return hashObjects(objects);
  }

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
