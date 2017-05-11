library epubreadertest;

import 'package:test/test.dart';
import 'package:epub/epub.dart';
import 'dart:io' as IO;
import 'package:path/path.dart' as path;

main() {  
  test("Test Author", () {  
   String fileName = "Alice.epub";
   String fullPath = path.join(IO.Directory.current.path, fileName);
   EpubBookRef epubRef = EpubReader.OpenBook(fullPath);
   
   expect( epubRef.Author, equals("Lewis Carroll"));  
  });
 }