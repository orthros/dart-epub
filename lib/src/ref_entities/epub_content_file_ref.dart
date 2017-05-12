import 'dart:async';
import 'dart:convert';

import 'package:archive/archive.dart';

import 'epub_book_ref.dart';
import '../entities/epub_content_type.dart';
import '../utils/zip_path_utils.dart';

abstract class EpubContentFileRef {
  EpubBookRef epubBookRef;

  EpubContentFileRef(EpubBookRef epubBookRef) {
    this.epubBookRef = epubBookRef;
  }

  String FileName;
  EpubContentType ContentType;
  String ContentMimeType;

  Future<List<int>> ReadContentAsBytesAsync() async {
    ArchiveFile contentFileEntry = getContentFileEntry();
    var content = openContentStream(contentFileEntry);
    return content;
  }

  Future<String> ReadContentAsTextAsync() async {
    List<int> contentStream = GetContentStream();
    String result = UTF8.decode(contentStream);
    return result;
  }

  List<int> GetContentStream() {
    return openContentStream(getContentFileEntry());
  }

  ArchiveFile getContentFileEntry() {
    String contentFilePath =
        ZipPathUtils.Combine(epubBookRef.Schema.ContentDirectoryPath, FileName);
    ArchiveFile contentFileEntry = epubBookRef.EpubArchive().files.firstWhere(
        (ArchiveFile x) => x.name == contentFilePath,
        orElse: () => null);
    if (contentFileEntry == null)
      throw new Exception(
          "EPUB parsing error: file ${contentFilePath} not found in archive.");
    return contentFileEntry;
  }

  List<int> openContentStream(ArchiveFile contentFileEntry) {
    List<int> contentStream = contentFileEntry.content;
    if (contentStream == null)
      throw new Exception(
          'Incorrect EPUB file: content file \"${FileName}\" specified in manifest is not found.');
    return contentStream;
  }
}
