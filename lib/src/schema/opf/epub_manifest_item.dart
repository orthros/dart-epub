import 'package:quiver/core.dart';

class EpubManifestItem {
  String Id;
  String Href;
  String MediaType;
  String RequiredNamespace;
  String RequiredModules;
  String Fallback;
  String FallbackStyle;

  @override
  int get hashCode => hashObjects([
        Id.hashCode,
        Href.hashCode,
        MediaType.hashCode,
        RequiredNamespace.hashCode,
        RequiredModules.hashCode,
        Fallback.hashCode,
        FallbackStyle.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubManifestItem;
    if (otherAs == null) {
      return false;
    }

    return Id == otherAs.Id &&
        Href == otherAs.Href &&
        MediaType == otherAs.MediaType &&
        RequiredNamespace == otherAs.RequiredNamespace &&
        RequiredModules == otherAs.RequiredModules &&
        Fallback == otherAs.Fallback &&
        FallbackStyle == otherAs.FallbackStyle;
  }

  String toString() {
    return "Id: ${Id}, Href = ${Href}, MediaType = ${MediaType}";
  }
}
