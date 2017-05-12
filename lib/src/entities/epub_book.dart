import 'epub_chapter.dart';
import 'epub_content.dart';
import 'epub_schema.dart';
import 'package:image/image.dart';

class EpubBook {
  String FilePath;
  String Title;
  String Author;
  List<String> AuthorList;
  EpubSchema Schema;
  EpubContent Content;
  Image CoverImage;
  List<EpubChapter> Chapters;
}
