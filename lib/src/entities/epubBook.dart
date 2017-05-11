import 'epubChapter.dart';
import 'epubContent.dart';
import 'epubSchema.dart';

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