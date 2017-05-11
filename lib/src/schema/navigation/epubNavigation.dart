import 'epubNavigationDocAuthor.dart';
import 'epubNavigationDocTitle.dart';
import 'epubNavigationHead.dart';
import 'epubNavigationList.dart';
import 'epubNavigationMap.dart';
import 'epubNavigationPageList.dart';

class EpubNavigation{
  EpubNavigationHead Head;
  EpubNavigationDocTitle DocTitle;
  List<EpubNavigationDocAuthor> DocAuthors;
  EpubNavigationMap NavMap;
  EpubNavigationPageList PageList;
  List<EpubNavigationList> NavLists;
}