import 'dart:async';

import 'epubBookRef.dart';
import 'epubContentFileRef.dart';

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef(EpubBookRef epubBookRef) : super(epubBookRef);

  String ReadContent() {
      return ReadContentAsText();
  }

  Future<String> ReadContentAsync() async {
      return ReadContentAsTextAsync();
  }
}