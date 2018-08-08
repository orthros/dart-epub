import 'package:quiver/core.dart';

import '../schema/navigation/epub_navigation.dart';
import '../schema/opf/epub_package.dart';

class EpubSchema {
  EpubPackage Package;
  EpubNavigation Navigation;
  String ContentDirectoryPath;

  @override
  int get hashCode => hash3(
      Package.hashCode, Navigation.hashCode, ContentDirectoryPath.hashCode);

  bool operator ==(other) {
    var otherAs = other as EpubSchema;
    if (otherAs == null) {
      return false;
    }

    return Package == otherAs.Package &&
        Navigation == otherAs.Navigation &&
        ContentDirectoryPath == otherAs.ContentDirectoryPath;
  }
}
