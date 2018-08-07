import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubChapter {
  String Title;
  String ContentFileName;
  String Anchor;
  String HtmlContent;
  List<EpubChapter> SubChapters;

  @override
  int get hashCode => hashObjects([
        Title.hashCode,
        ContentFileName.hashCode,
        Anchor.hashCode,
        HtmlContent.hashCode,
        SubChapters.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubChapter;
    if (otherAs == null) {
      return false;
    }
    return Title == otherAs.Title &&
        ContentFileName == otherAs.ContentFileName &&
        Anchor == otherAs.Anchor &&
        HtmlContent == otherAs.HtmlContent &&
        collections.listsEqual(SubChapters, otherAs.SubChapters);
  }

  String toString() {
    return "Title: ${Title}, Subchapter count: ${SubChapters.length}";
  }
}
