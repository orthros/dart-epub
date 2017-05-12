import 'epub_navigation_doc_author.dart';
import 'epub_navigation_doc_title.dart';
import 'epub_navigation_head.dart';
import 'epub_navigation_list.dart';
import 'epub_navigation_map.dart';
import 'epub_navigation_page_list.dart';

class EpubNavigation {
  EpubNavigationHead Head;
  EpubNavigationDocTitle DocTitle;
  List<EpubNavigationDocAuthor> DocAuthors;
  EpubNavigationMap NavMap;
  EpubNavigationPageList PageList;
  List<EpubNavigationList> NavLists;
}
