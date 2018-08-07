import 'dart:async';

import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  EpubTextContentFileRef epubTextContentFileRef;

  String Title;
  String ContentFileName;
  String Anchor;
  List<EpubChapterRef> SubChapters;

  EpubChapterRef(EpubTextContentFileRef epubTextContentFileRef) {
    this.epubTextContentFileRef = epubTextContentFileRef;
  }

  @override
  int get hashCode => hashObjects([
        Title.hashCode,
        ContentFileName.hashCode,
        Anchor.hashCode,
        epubTextContentFileRef.hashCode,
        SubChapters.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubChapterRef;
    if (otherAs == null) {
      return false;
    }
    return Title == otherAs.Title &&
        ContentFileName == otherAs.ContentFileName &&
        Anchor == otherAs.Anchor &&
        epubTextContentFileRef == otherAs.epubTextContentFileRef &&
        collections.listsEqual(SubChapters, otherAs.SubChapters);
  }

  Future<String> readHtmlContent() async {
    return epubTextContentFileRef.readContentAsText();
  }

  String toString() {
    return "Title: ${Title}, Subchapter count: ${SubChapters.length}";
  }
}
