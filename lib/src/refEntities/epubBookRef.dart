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
  
  Future<Image> ReadCoverAsync() async {
      return await BookCoverReader.ReadBookCoverAsync(this);
  }  

  Future<List<EpubChapterRef>> GetChaptersAsync() async {
      return await ChapterReader.GetChapters(this);
  }
}