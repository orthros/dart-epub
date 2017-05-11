import 'dart:async';
import 'dart:convert';

import '../entities/epubContentType.dart';
import 'epubBookRef.dart';
import '../utils/zipPathUtils.dart';

import 'package:archive/archive.dart';

abstract class EpubContentFileRef {
    EpubBookRef epubBookRef;

    EpubContentFileRef(EpubBookRef epubBookRef) {
        this.epubBookRef = epubBookRef;
    }

    String FileName;
    EpubContentType ContentType;
    String ContentMimeType;

    List<int> ReadContentAsBytes() {
      List<int> result;
      Future.wait([ReadContentAsBytesAsync()])
            .then((List responses) => result = responses.first);
      return result;
    }

    Future<List<int>> ReadContentAsBytesAsync() async {
        ArchiveFile contentFileEntry = getContentFileEntry();
        var content = openContentStream(contentFileEntry);        
        return content;
    }

    String ReadContentAsText() {
      String result = "";
      Future.wait([ReadContentAsTextAsync()])
            .then((List responses) => result = responses.first);
      return result;
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
        String contentFilePath = ZipPathUtils.Combine(epubBookRef.Schema.ContentDirectoryPath, FileName);
        ArchiveFile contentFileEntry = epubBookRef.EpubArchive
                                                  .files
                                                  .firstWhere((ArchiveFile x) => x.name == contentFilePath, orElse: () => null);
        if (contentFileEntry == null)
            throw new Exception("EPUB parsing error: file ${contentFilePath} not found in archive.");
        return contentFileEntry;
    }

    List<int> openContentStream(ArchiveFile contentFileEntry) {
        List<int> contentStream = contentFileEntry.content;
        if (contentStream == null)
            throw new Exception('Incorrect EPUB file: content file \"${FileName}\" specified in manifest is not found.');
        return contentStream;
    }    
}