library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub/epub.dart';
import 'package:epub/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = new Archive();
  EpubBookRef ref = new EpubBookRef(arch);

  var reference = new EpubByteContentFileRef(ref);
  reference
    ..ContentMimeType = "application/test"
    ..ContentType = EpubContentType.OTHER
    ..FileName = "orthrosFile";

  EpubByteContentFileRef testFileRef;

  setUp(() async {
    Archive arch2 = new Archive();
    EpubBookRef ref2 = new EpubBookRef(arch2);

    testFileRef = new EpubByteContentFileRef(ref2);
    testFileRef
      ..ContentMimeType = reference.ContentMimeType
      ..ContentType = reference.ContentType
      ..FileName = reference.FileName;
  });

  tearDown(() async {
    testFileRef = null;
  });

  group("EpubByteContentFileRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFileRef, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFileRef.ContentMimeType = "application/different";
        expect(testFileRef, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFileRef.ContentType = EpubContentType.CSS;
        expect(testFileRef, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFileRef.FileName = "a_different_file_name.txt";
        expect(testFileRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFileRef.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFileRef.ContentMimeType = "application/orthros";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFileRef.ContentType = EpubContentType.CSS;
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFileRef.FileName = "a_different_file_name";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
