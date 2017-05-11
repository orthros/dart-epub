library epubreadertest;

import 'package:test/test.dart';
import 'package:epub/epub.dart';
import 'dart:io' as IO;
import 'package:path/path.dart' as path;

main() async {  
  await test("Test Epub Ref", () async {  
   String fileName = "Alice.epub";
   String fullPath = path.join(IO.Directory.current.path, fileName);
   EpubBookRef epubRef = await EpubReader.OpenBookAsync(fullPath);
   
   expect(epubRef.Author, equals("Lewis Carroll"));  
   expect(epubRef.Title, equals("Alice's Adventures in Wonderland"));
  });
  await test("Test Epub Read", () async {
    String fileName = "Alice.epub";
    String fullPath = path.join(IO.Directory.current.path, fileName);
    EpubBook epubRef = await EpubReader.ReadBookAsync(fullPath);
   
    expect(epubRef.Author, equals("Lewis Carroll"));  
    expect(epubRef.Title, equals("Alice's Adventures in Wonderland"));
  });
 }