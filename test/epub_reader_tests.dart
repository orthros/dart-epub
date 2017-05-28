library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epub/epub.dart';

main() async {
  String fileName = "hittelOnGoldMines.epub";
  String fullPath = path.join(io.Directory.current.path, "test", fileName);
  var targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();
  await test("Test Epub Ref", () async {
    EpubBookRef epubRef = await EpubReader.openBook(bytes);

    expect(epubRef.Author, equals("John S. Hittell"));
    expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
  });
  await test("Test Epub Read", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);

    expect(epubRef.Author, equals("John S. Hittell"));
    expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
  });
}
