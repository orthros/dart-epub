library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epub/epub.dart';

main() async {
  String fileName = "alicesAdventuresUnderGround.epub";
  String fullPath = path.join(io.Directory.current.path, "test", fileName);
  var targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }
  List<int> bytes = await targetFile.readAsBytes();
  await test("Test Epub Image", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);

    expect(epubRef.CoverImage, isNotNull);

    expect(3, epubRef.CoverImage.format);
    expect(581, epubRef.CoverImage.width);
    expect(1034, epubRef.CoverImage.height);
  });
}
