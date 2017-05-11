import 'dart:async';

import 'epubBookRef.dart';
import 'epubContentFileRef.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  
  EpubByteContentFileRef(EpubBookRef epubBookRef) : super(epubBookRef);

  List<int> ReadContent() {
      return ReadContentAsBytes();
  }

  Future<List<int>> ReadContentAsync() {
      return ReadContentAsBytesAsync();
  }
}
