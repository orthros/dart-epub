class EpubManifestItem {
  String Id;
  String Href;
  String MediaType;
  String RequiredNamespace;
  String RequiredModules;
  String Fallback;
  String FallbackStyle;

  String toString() {
    return "Id: ${Id}, Href = ${Href}, MediaType = ${MediaType}";
  }
}
