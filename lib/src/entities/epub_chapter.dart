class EpubChapter {
  String Title;
  String ContentFileName;
  String Anchor;
  String HtmlContent;
  List<EpubChapter> SubChapters;

  String toString() {
    return "Title: ${Title}, Subchapter count: ${SubChapters.length}";
  }
}
