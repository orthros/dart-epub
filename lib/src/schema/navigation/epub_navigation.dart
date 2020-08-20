import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

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

  @override
  int get hashCode {
    var objects = []
      ..add(Head.hashCode)
      ..add(DocTitle.hashCode)
      ..add(NavMap.hashCode)
      ..add(PageList.hashCode)
      ..addAll(DocAuthors?.map((author) => author.hashCode) ?? [0])
      ..addAll(NavLists?.map((navList) => navList.hashCode) ?? [0]);
    return hashObjects(objects);
  }

  bool operator ==(other) {
    var otherAs = other as EpubNavigation;
    if (otherAs == null) {
      return false;
    }

    if (!collections.listsEqual(DocAuthors, otherAs.DocAuthors)) {
      return false;
    }
    if (!collections.listsEqual(NavLists, otherAs.NavLists)) {
      return false;
    }

    return Head == otherAs.Head &&
        DocTitle == otherAs.DocTitle &&
        NavMap == otherAs.NavMap &&
        PageList == otherAs.PageList;
  }
}
