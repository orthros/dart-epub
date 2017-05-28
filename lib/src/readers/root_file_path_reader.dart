import 'dart:async';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;

class RootFilePathReader {
  static Future<String> getRootFilePath(Archive epubArchive) async {
    const String EPUB_CONTAINER_FILE_PATH = "META-INF/container.xml";

    ArchiveFile containerFileEntry = epubArchive.files.firstWhere(
        (ArchiveFile file) => file.name == EPUB_CONTAINER_FILE_PATH,
        orElse: () => null);
    if (containerFileEntry == null) {
      throw new Exception(
          "EPUB parsing error: ${EPUB_CONTAINER_FILE_PATH} file not found in archive.");
    }

    xml.XmlDocument containerDocument =
        xml.parse(UTF8.decode(containerFileEntry.content));
    xml.XmlElement packageElement = containerDocument
        .findAllElements("container",
            namespace: "urn:oasis:names:tc:opendocument:xmlns:container")
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (packageElement == null) {
      throw new Exception("EPUB parsing error: Invalid epub container");
    }

    xml.XmlElement rootFileElement = packageElement.descendants.firstWhere(
        (xml.XmlNode testElem) =>
            (testElem is xml.XmlElement) && "rootfile" == testElem.name.local,
        orElse: () => null);

    return rootFileElement.getAttribute("full-path");
  }
}
