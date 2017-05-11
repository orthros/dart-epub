import 'dart:async';

import 'epubTextContentFileRef.dart';

class EpubChapterRef {
    EpubTextContentFileRef epubTextContentFileRef;

    EpubChapterRef(EpubTextContentFileRef epubTextContentFileRef)
    {
        this.epubTextContentFileRef = epubTextContentFileRef;
    }

    String Title;
    String ContentFileName;
    String Anchor;
    List<EpubChapterRef> SubChapters;

    String ReadHtmlContent() {
        String result = "";
        Future.wait([ReadHtmlContentAsync()])
              .then((List results) => result = results.first);
        return result;
    }

    Future<String> ReadHtmlContentAsync() async {
        return epubTextContentFileRef.ReadContentAsTextAsync();
    }

    String toString() {
        return "Title: ${Title}, Subchapter count: ${SubChapters.length}";
    }
}