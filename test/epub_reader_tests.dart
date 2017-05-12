library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epub/epub.dart';

main() async {
  String fileName = "hittelOnGoldMines.epub";
  String fullPath = path.join(io.Directory.current.path, "test", fileName);

  await test("Test Epub Ref", () async {
    EpubBookRef epubRef = await EpubReader.OpenBookAsync(fullPath);

    expect(epubRef.Author, equals("John S. Hittell"));
    expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
  });
  await test("Test Epub Read", () async {
    EpubBook epubRef = await EpubReader.ReadBookAsync(fullPath);

    expect(epubRef.Author, equals("John S. Hittell"));
    expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
  });
}
