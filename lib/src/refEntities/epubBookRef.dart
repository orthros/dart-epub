import 'dart:async';

import '../entities/epubSchema.dart';
import '../readers/bookCoverReader.dart';
import '../readers/chapterReader.dart';
import 'epubChapterRef.dart';
import 'epubContentRef.dart';

import 'package:archive/archive.dart';
import 'package:image/image.dart';

class EpubBookRef {
  Archive epubArchive;
  
  EpubBookRef(Archive epubArchive) {
      this.epubArchive = epubArchive;
  }
  
  String FilePath;
  String Title;
  String Author;
  List<String> AuthorList;
  EpubSchema Schema;
  EpubContentRef Content;

  Archive EpubArchive() {
    return epubArchive;
  }

  Image ReadCover() {
    Image retval;
    Future.wait([ReadCoverAsync()]).then((List<Image> res) => retval = res.first);
    return retval;
  }

  Future<Image> ReadCoverAsync() async {
      return await BookCoverReader.ReadBookCoverAsync(this);
  }

  List<EpubChapterRef> GetChapters() {
    List<EpubChapterRef> res;
    Future.wait([GetChaptersAsync()]).then((List<List<EpubChapterRef>> result)=> res = result.first);
    return res;
  }

  Future<List<EpubChapterRef>> GetChaptersAsync() async {
      return await ChapterReader.GetChapters(this);
  }
}