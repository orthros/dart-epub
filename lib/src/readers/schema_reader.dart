import 'dart:async';

import '../entities/epubSchema.dart';
import '../schema/navigation/epubNavigation.dart';
import '../schema/opf/epubPackage.dart';
import '../utils/zipPathUtils.dart';
import 'navigationReader.dart';
import 'rootFilePathReader.dart';
import 'packageReader.dart';

import 'package:archive/archive.dart';

class SchemaReader {
  static Future<EpubSchema> ReadSchemaAsync(Archive epubArchive) async {
      EpubSchema result = new EpubSchema();
      String rootFilePath = await RootFilePathReader.GetRootFilePathAsync(epubArchive);
      String contentDirectoryPath = ZipPathUtils.GetDirectoryPath(rootFilePath);
      result.ContentDirectoryPath = contentDirectoryPath;
      EpubPackage package = await PackageReader.ReadPackageAsync(epubArchive, rootFilePath);
      result.Package = package;
      EpubNavigation navigation = await NavigationReader.ReadNavigationAsync(epubArchive, contentDirectoryPath, package);
      result.Navigation = navigation;
      return result;
  }
}