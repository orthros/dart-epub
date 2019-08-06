import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/opf/epub_package.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

class SchemaReader {
  static Future<EpubSchema> readSchema(Archive epubArchive) async {
    EpubSchema result = EpubSchema();

    String rootFilePath = await RootFilePathReader.getRootFilePath(epubArchive);
    String contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    result.ContentDirectoryPath = contentDirectoryPath;

    EpubPackage package =
        await PackageReader.readPackage(epubArchive, rootFilePath);
    result.Package = package;

    EpubNavigation navigation = await NavigationReader.readNavigation(
        epubArchive, contentDirectoryPath, package);
    result.Navigation = navigation;

    return result;
  }
}
