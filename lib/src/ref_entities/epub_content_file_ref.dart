import 'dart:async';

import 'package:archive/archive.dart';
import 'package:dart2_constant/convert.dart' as convert;
import 'package:quiver/core.dart';

import '../entities/epub_content_type.dart';
import '../utils/zip_path_utils.dart';
import 'epub_book_ref.dart';

abstract class EpubContentFileRef {
  EpubBookRef epubBookRef;

  String FileName;

  EpubContentType ContentType;
  String ContentMimeType;
  EpubContentFileRef(EpubBookRef epubBookRef) {
    this.epubBookRef = epubBookRef;
  }

  @override
  int get hashCode =>
      hash3(FileName.hashCode, ContentMimeType.hashCode, ContentType.hashCode);

  bool operator ==(other) {
    return (other is EpubContentFileRef &&
        other.FileName == FileName &&
        other.ContentMimeType == ContentMimeType &&
        other.ContentType == ContentType);
  }

  ArchiveFile getContentFileEntry() {
    String contentFilePath =
        ZipPathUtils.combine(epubBookRef.Schema.ContentDirectoryPath, FileName);
    ArchiveFile contentFileEntry = epubBookRef.EpubArchive().files.firstWhere(
        (ArchiveFile x) => x.name == contentFilePath,
        orElse: () => null);
    if (contentFileEntry == null) {
      throw Exception(
          "EPUB parsing error: file ${contentFilePath} not found in archive.");
    }
    return contentFileEntry;
  }

  List<int> getContentStream() {
    return openContentStream(getContentFileEntry());
  }

  List<int> openContentStream(ArchiveFile contentFileEntry) {
    List<int> contentStream = List<int>();
    if (contentFileEntry.content == null) {
      throw Exception(
          'Incorrect EPUB file: content file \"${FileName}\" specified in manifest is not found.');
    }
    contentStream.addAll(contentFileEntry.content);
    return contentStream;
  }

  Future<List<int>> readContentAsBytes() async {
    ArchiveFile contentFileEntry = getContentFileEntry();
    var content = openContentStream(contentFileEntry);
    return content;
  }

  Future<String> readContentAsText() async {
    List<int> contentStream = getContentStream();
    String result = convert.utf8.decode(contentStream);
    return result;
  }
}
