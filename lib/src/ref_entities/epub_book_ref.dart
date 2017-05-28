import 'dart:async';

import 'package:archive/archive.dart';
import 'package:image/image.dart';

import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';
import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';

class EpubBookRef {
  Archive _epubArchive;

  EpubBookRef(Archive epubArchive) {
    this._epubArchive = epubArchive;
  }

  String FilePath;
  String Title;
  String Author;
  List<String> AuthorList;
  EpubSchema Schema;
  EpubContentRef Content;

  Archive EpubArchive() {
    return _epubArchive;
  }

  Future<Image> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return await ChapterReader.getChapters(this);
  }
}
