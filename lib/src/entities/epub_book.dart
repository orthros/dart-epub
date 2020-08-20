import 'package:image/image.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_chapter.dart';
import 'epub_content.dart';
import 'epub_schema.dart';

class EpubBook {
  String Title;
  String Author;
  List<String> AuthorList;
  EpubSchema Schema;
  EpubContent Content;
  Image CoverImage;
  List<EpubChapter> Chapters;

  @override
  int get hashCode {
    var objects = []
      ..add(Title.hashCode)
      ..add(Author.hashCode)
      ..add(Schema.hashCode)
      ..add(Content.hashCode)
      ..add(CoverImage.hashCode)
      ..addAll(AuthorList?.map((author) => author.hashCode) ?? [0])
      ..addAll(Chapters?.map((chapter) => chapter.hashCode) ?? [0]);
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubBook;
    if (otherAs == null) {
      return false;
    }

    return Title == otherAs.Title &&
        Author == otherAs.Author &&
        collections.listsEqual(AuthorList, otherAs.AuthorList) &&
        Schema == otherAs.Schema &&
        Content == otherAs.Content &&
        collections.listsEqual(
            CoverImage.getBytes(), otherAs.CoverImage.getBytes()) &&
        collections.listsEqual(Chapters, otherAs.Chapters);
  }
}
