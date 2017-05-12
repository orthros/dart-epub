import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

class ChapterReader {
  static List<EpubChapterRef> GetChapters(EpubBookRef bookRef) {
    return GetChaptersImpl(bookRef, bookRef.Schema.Navigation.NavMap.Points);
  }

  static List<EpubChapterRef> GetChaptersImpl(
      EpubBookRef bookRef, List<EpubNavigationPoint> navigationPoints) {
    List<EpubChapterRef> result = new List<EpubChapterRef>();
    navigationPoints.forEach((EpubNavigationPoint navigationPoint) {
      String contentFileName;
      String anchor;
      int contentSourceAnchorCharIndex =
          navigationPoint.Content.Source.indexOf('#');
      if (contentSourceAnchorCharIndex == -1) {
        contentFileName = navigationPoint.Content.Source;
        anchor = null;
      } else {
        contentFileName = navigationPoint.Content.Source
            .substring(0, contentSourceAnchorCharIndex);
        anchor = navigationPoint.Content.Source
            .substring(contentSourceAnchorCharIndex + 1);
      }

      EpubTextContentFileRef htmlContentFileRef;
      if (!bookRef.Content.Html.containsKey(contentFileName)) {
        throw new Exception(
            "Incorrect EPUB manifest: item with href = \"${contentFileName}\" is missing.");
      }

      htmlContentFileRef = bookRef.Content.Html[contentFileName];
      EpubChapterRef chapterRef = new EpubChapterRef(htmlContentFileRef);
      chapterRef.ContentFileName = contentFileName;
      chapterRef.Anchor = anchor;
      chapterRef.Title = navigationPoint.NavigationLabels.first.Text;
      chapterRef.SubChapters =
          GetChaptersImpl(bookRef, navigationPoint.ChildNavigationPoints);

      result.add(chapterRef);
    });
    return result;
  }
}
