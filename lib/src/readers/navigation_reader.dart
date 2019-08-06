import 'dart:async';

import 'package:archive/archive.dart';
import 'package:dart2_constant/convert.dart' as convert;
import 'package:epub/src/schema/opf/epub_version.dart';
import 'package:xml/xml.dart' as xml;

import '../schema/navigation/epub_metadata.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../schema/navigation/epub_navigation_page_target.dart';
import '../schema/navigation/epub_navigation_page_target_type.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_package.dart';
import '../utils/enum_from_string.dart';
import '../utils/zip_path_utils.dart';

class NavigationReader {
  static Future<EpubNavigation> readNavigation(Archive epubArchive,
      String contentDirectoryPath, EpubPackage package) async {
    EpubNavigation result = EpubNavigation();
    String tocId = package.Spine.TableOfContents;
    if (tocId == null || tocId.isEmpty) {
      if (package.Version == EpubVersion.Epub2) {
        throw Exception("EPUB parsing error: TOC ID is empty.");
      }
      return null;
    }

    EpubManifestItem tocManifestItem = package.Manifest.Items.firstWhere(
        (EpubManifestItem item) => item.Id.toLowerCase() == tocId.toLowerCase(),
        orElse: () => null);
    if (tocManifestItem == null) {
      throw Exception(
          "EPUB parsing error: TOC item ${tocId} not found in EPUB manifest.");
    }

    String tocFileEntryPath =
        ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.Href);
    ArchiveFile tocFileEntry = epubArchive.files.firstWhere(
        (ArchiveFile file) =>
            file.name.toLowerCase() == tocFileEntryPath.toLowerCase(),
        orElse: () => null);
    if (tocFileEntry == null) {
      throw Exception(
          "EPUB parsing error: TOC file ${tocFileEntryPath} not found in archive.");
    }

    xml.XmlDocument containerDocument =
        xml.parse(convert.utf8.decode(tocFileEntry.content));

    String ncxNamespace = "http://www.daisy.org/z3986/2005/ncx/";
    xml.XmlElement ncxNode = containerDocument
        .findAllElements("ncx", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (ncxNode == null) {
      throw Exception(
          "EPUB parsing error: TOC file does not contain ncx element.");
    }

    xml.XmlElement headNode = ncxNode
        .findAllElements("head", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (headNode == null) {
      throw Exception(
          "EPUB parsing error: TOC file does not contain head element.");
    }

    EpubNavigationHead navigationHead = readNavigationHead(headNode);
    result.Head = navigationHead;
    xml.XmlElement docTitleNode = ncxNode
        .findElements("docTitle", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (docTitleNode == null) {
      throw Exception(
          "EPUB parsing error: TOC file does not contain docTitle element.");
    }

    EpubNavigationDocTitle navigationDocTitle =
        readNavigationDocTitle(docTitleNode);
    result.DocTitle = navigationDocTitle;
    result.DocAuthors = List<EpubNavigationDocAuthor>();
    ncxNode
        .findElements("docAuthor", namespace: ncxNamespace)
        .forEach((xml.XmlElement docAuthorNode) {
      EpubNavigationDocAuthor navigationDocAuthor =
          readNavigationDocAuthor(docAuthorNode);
      result.DocAuthors.add(navigationDocAuthor);
    });

    xml.XmlElement navMapNode = ncxNode
        .findElements("navMap", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (navMapNode == null) {
      throw Exception(
          "EPUB parsing error: TOC file does not contain navMap element.");
    }

    EpubNavigationMap navMap = readNavigationMap(navMapNode);
    result.NavMap = navMap;
    xml.XmlElement pageListNode = ncxNode
        .findElements("pageList", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (pageListNode != null) {
      EpubNavigationPageList pageList = readNavigationPageList(pageListNode);
      result.PageList = pageList;
    }

    result.NavLists = List<EpubNavigationList>();
    ncxNode
        .findElements("navList", namespace: ncxNamespace)
        .forEach((xml.XmlElement navigationListNode) {
      EpubNavigationList navigationList =
          readNavigationList(navigationListNode);
      result.NavLists.add(navigationList);
    });

    return result;
  }

  static EpubNavigationContent readNavigationContent(
      xml.XmlElement navigationContentNode) {
    EpubNavigationContent result = EpubNavigationContent();
    navigationContentNode.attributes
        .forEach((xml.XmlAttribute navigationContentNodeAttribute) {
      String attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "src":
          result.Source = attributeValue;
          break;
      }
    });
    if (result.Source == null || result.Source.isEmpty) {
      throw Exception(
          "Incorrect EPUB navigation content: content source is missing.");
    }

    return result;
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(
      xml.XmlElement docAuthorNode) {
    EpubNavigationDocAuthor result = EpubNavigationDocAuthor();
    result.Authors = List<String>();
    docAuthorNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == "text") {
        result.Authors.add(textNode.text);
      }
    });
    return result;
  }

  static EpubNavigationDocTitle readNavigationDocTitle(
      xml.XmlElement docTitleNode) {
    EpubNavigationDocTitle result = EpubNavigationDocTitle();
    result.Titles = List<String>();
    docTitleNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == "text") {
        result.Titles.add(textNode.text);
      }
    });
    return result;
  }

  static EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
    EpubNavigationHead result = EpubNavigationHead();
    result.Metadata = List<EpubNavigationHeadMeta>();

    headNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement metaNode) {
      if (metaNode.name.local.toLowerCase() == "meta") {
        EpubNavigationHeadMeta meta = EpubNavigationHeadMeta();
        metaNode.attributes.forEach((xml.XmlAttribute metaNodeAttribute) {
          String attributeValue = metaNodeAttribute.value;
          switch (metaNodeAttribute.name.local.toLowerCase()) {
            case "name":
              meta.Name = attributeValue;
              break;
            case "content":
              meta.Content = attributeValue;
              break;
            case "scheme":
              meta.Scheme = attributeValue;
              break;
          }
        });

        if (meta.Name == null || meta.Name.isEmpty) {
          throw Exception(
              "Incorrect EPUB navigation meta: meta name is missing.");
        }
        if (meta.Content == null) {
          throw Exception(
              "Incorrect EPUB navigation meta: meta content is missing.");
        }

        result.Metadata.add(meta);
      }
    });
    return result;
  }

  static EpubNavigationLabel readNavigationLabel(
      xml.XmlElement navigationLabelNode) {
    EpubNavigationLabel result = EpubNavigationLabel();

    xml.XmlElement navigationLabelTextNode = navigationLabelNode
        .findElements("text", namespace: navigationLabelNode.name.namespaceUri)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (navigationLabelTextNode == null) {
      throw Exception(
          "Incorrect EPUB navigation label: label text element is missing.");
    }

    result.Text = navigationLabelTextNode.text;

    return result;
  }

  static EpubNavigationList readNavigationList(
      xml.XmlElement navigationListNode) {
    EpubNavigationList result = EpubNavigationList();
    navigationListNode.attributes
        .forEach((xml.XmlAttribute navigationListNodeAttribute) {
      String attributeValue = navigationListNodeAttribute.value;
      switch (navigationListNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "class":
          result.Class = attributeValue;
          break;
      }
    });
    navigationListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationListChildNode) {
      switch (navigationListChildNode.name.local.toLowerCase()) {
        case "navlabel":
          EpubNavigationLabel navigationLabel =
              readNavigationLabel(navigationListChildNode);
          result.NavigationLabels.add(navigationLabel);
          break;
        case "navtarget":
          EpubNavigationTarget navigationTarget =
              readNavigationTarget(navigationListChildNode);
          result.NavigationTargets.add(navigationTarget);
          break;
      }
    });
    if (result.NavigationLabels.isEmpty) {
      throw Exception(
          "Incorrect EPUB navigation page target: at least one navLabel element is required.");
    }
    return result;
  }

  static EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
    EpubNavigationMap result = EpubNavigationMap();
    result.Points = List<EpubNavigationPoint>();
    navigationMapNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == "navpoint") {
        EpubNavigationPoint navigationPoint =
            readNavigationPoint(navigationPointNode);
        result.Points.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationPageList readNavigationPageList(
      xml.XmlElement navigationPageListNode) {
    EpubNavigationPageList result = EpubNavigationPageList();
    result.Targets = List<EpubNavigationPageTarget>();
    navigationPageListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement pageTargetNode) {
      if (pageTargetNode.name.local == "pageTarget") {
        EpubNavigationPageTarget pageTarget =
            readNavigationPageTarget(pageTargetNode);
        result.Targets.add(pageTarget);
      }
    });

    return result;
  }

  static EpubNavigationPageTarget readNavigationPageTarget(
      xml.XmlElement navigationPageTargetNode) {
    EpubNavigationPageTarget result = EpubNavigationPageTarget();
    result.NavigationLabels = List<EpubNavigationLabel>();
    navigationPageTargetNode.attributes
        .forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      String attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "value":
          result.Value = attributeValue;
          break;
        case "type":
          var converter = EnumFromString<EpubNavigationPageTargetType>(
              EpubNavigationPageTargetType.values);
          EpubNavigationPageTargetType type = converter.get(attributeValue);
          result.Type = type;
          break;
        case "class":
          result.Class = attributeValue;
          break;
        case "playorder":
          result.PlayOrder = attributeValue;
          break;
      }
    });
    if (result.Type == EpubNavigationPageTargetType.UNDEFINED) {
      throw Exception(
          "Incorrect EPUB navigation page target: page target type is missing.");
    }

    navigationPageTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPageTargetChildNode) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case "navlabel":
          EpubNavigationLabel navigationLabel =
              readNavigationLabel(navigationPageTargetChildNode);
          result.NavigationLabels.add(navigationLabel);
          break;
        case "content":
          EpubNavigationContent content =
              readNavigationContent(navigationPageTargetChildNode);
          result.Content = content;
          break;
      }
    });
    if (result.NavigationLabels.isEmpty) {
      throw Exception(
          "Incorrect EPUB navigation page target: at least one navLabel element is required.");
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPoint(
      xml.XmlElement navigationPointNode) {
    EpubNavigationPoint result = EpubNavigationPoint();
    navigationPointNode.attributes
        .forEach((xml.XmlAttribute navigationPointNodeAttribute) {
      String attributeValue = navigationPointNodeAttribute.value;
      switch (navigationPointNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "class":
          result.Class = attributeValue;
          break;
        case "playorder":
          result.PlayOrder = attributeValue;
          break;
      }
    });
    if (result.Id == null || result.Id.isEmpty) {
      throw Exception("Incorrect EPUB navigation point: point ID is missing.");
    }

    result.NavigationLabels = List<EpubNavigationLabel>();
    result.ChildNavigationPoints = List<EpubNavigationPoint>();
    navigationPointNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case "navlabel":
          EpubNavigationLabel navigationLabel =
              readNavigationLabel(navigationPointChildNode);
          result.NavigationLabels.add(navigationLabel);
          break;
        case "content":
          EpubNavigationContent content =
              readNavigationContent(navigationPointChildNode);
          result.Content = content;
          break;
        case "navpoint":
          EpubNavigationPoint childNavigationPoint =
              readNavigationPoint(navigationPointChildNode);
          result.ChildNavigationPoints.add(childNavigationPoint);
          break;
      }
    });

    if (result.NavigationLabels.isEmpty) {
      throw Exception(
          "EPUB parsing error: navigation point ${result.Id} should contain at least one navigation label.");
    }
    if (result.Content == null) {
      throw Exception(
          "EPUB parsing error: navigation point ${result.Id} should contain content.");
    }

    return result;
  }

  static EpubNavigationTarget readNavigationTarget(
      xml.XmlElement navigationTargetNode) {
    EpubNavigationTarget result = EpubNavigationTarget();
    navigationTargetNode.attributes
        .forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      String attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "value":
          result.Value = attributeValue;
          break;
        case "class":
          result.Class = attributeValue;
          break;
        case "playorder":
          result.PlayOrder = attributeValue;
          break;
      }
    });
    if (result.Id == null || result.Id.isEmpty) {
      throw Exception(
          "Incorrect EPUB navigation target: navigation target ID is missing.");
    }

    navigationTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationTargetChildNode) {
      switch (navigationTargetChildNode.name.local.toLowerCase()) {
        case "navlabel":
          EpubNavigationLabel navigationLabel =
              readNavigationLabel(navigationTargetChildNode);
          result.NavigationLabels.add(navigationLabel);
          break;
        case "content":
          EpubNavigationContent content =
              readNavigationContent(navigationTargetChildNode);
          result.Content = content;
          break;
      }
    });
    if (result.NavigationLabels.isEmpty) {
      throw Exception(
          "Incorrect EPUB navigation target: at least one navLabel element is required.");
    }

    return result;
  }
}
