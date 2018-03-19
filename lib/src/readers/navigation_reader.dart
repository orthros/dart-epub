import 'dart:async';
import 'dart:convert';

import 'package:xml/xml.dart' as xml;
import 'package:archive/archive.dart';

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
    EpubNavigation result = new EpubNavigation();
    String tocId = package.Spine.TableOfContents;
    if (tocId == null || tocId.isEmpty) {
      throw new Exception("EPUB parsing error: TOC ID is empty.");
    }

    EpubManifestItem tocManifestItem = package.Manifest.Items.firstWhere(
        (EpubManifestItem item) => item.Id.toLowerCase() == tocId.toLowerCase(),
        orElse: () => null);
    if (tocManifestItem == null) {
      throw new Exception(
          "EPUB parsing error: TOC item ${tocId} not found in EPUB manifest.");
    }

    String tocFileEntryPath =
        ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.Href);
    ArchiveFile tocFileEntry = epubArchive.files.firstWhere(
        (ArchiveFile file) =>
            file.name.toLowerCase() == tocFileEntryPath.toLowerCase(),
        orElse: () => null);
    if (tocFileEntry == null) {
      throw new Exception(
          "EPUB parsing error: TOC file ${tocFileEntryPath} not found in archive.");
    }

    xml.XmlDocument containerDocument =
        xml.parse(UTF8.decode(tocFileEntry.content));

    String ncxNamespace = "http://www.daisy.org/z3986/2005/ncx/";
    xml.XmlElement ncxNode = containerDocument
        .findAllElements("ncx", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (ncxNode == null) {
      throw new Exception(
          "EPUB parsing error: TOC file does not contain ncx element.");
    }

    xml.XmlElement headNode = ncxNode
        .findAllElements("head", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (headNode == null) {
      throw new Exception(
          "EPUB parsing error: TOC file does not contain head element.");
    }

    EpubNavigationHead navigationHead = readNavigationHead(headNode);
    result.Head = navigationHead;
    xml.XmlElement docTitleNode = ncxNode
        .findElements("docTitle", namespace: ncxNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (docTitleNode == null) {
      throw new Exception(
          "EPUB parsing error: TOC file does not contain docTitle element.");
    }

    EpubNavigationDocTitle navigationDocTitle =
        readNavigationDocTitle(docTitleNode);
    result.DocTitle = navigationDocTitle;
    result.DocAuthors = new List<EpubNavigationDocAuthor>();
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
      throw new Exception(
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

    result.NavLists = new List<EpubNavigationList>();
    ncxNode
        .findElements("navList", namespace: ncxNamespace)
        .forEach((xml.XmlElement navigationListNode) {
      EpubNavigationList navigationList =
          readNavigationList(navigationListNode);
      result.NavLists.add(navigationList);
    });

    return result;
  }

  static EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
    EpubNavigationHead result = new EpubNavigationHead();
    result.Metadata = new List<EpubNavigationHeadMeta>();

    headNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement metaNode) {
      if (metaNode.name.local.toLowerCase() == "meta") {
        EpubNavigationHeadMeta meta = new EpubNavigationHeadMeta();
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
          throw new Exception(
              "Incorrect EPUB navigation meta: meta name is missing.");
        }
        if (meta.Content == null) {
          throw new Exception(
              "Incorrect EPUB navigation meta: meta content is missing.");
        }

        result.Metadata.add(meta);
      }
    });
    return result;
  }

  static EpubNavigationDocTitle readNavigationDocTitle(
      xml.XmlElement docTitleNode) {
    EpubNavigationDocTitle result = new EpubNavigationDocTitle();
    result.Titles = new List<String>();
    docTitleNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == "text") {
        result.Titles.add(textNode.text);
      }
    });
    return result;
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(
      xml.XmlElement docAuthorNode) {
    EpubNavigationDocAuthor result = new EpubNavigationDocAuthor();
    result.Authors = new List<String>();
    docAuthorNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == "text") {
        result.Authors.add(textNode.text);
      }
    });
    return result;
  }

  static EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
    EpubNavigationMap result = new EpubNavigationMap();
    result.Points = new List<EpubNavigationPoint>();
    navigationMapNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == "navpoint") {
        EpubNavigationPoint navigationPoint =
            readNavigationPoint(navigationPointNode);
        result.Points.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationPoint readNavigationPoint(
      xml.XmlElement navigationPointNode) {
    EpubNavigationPoint result = new EpubNavigationPoint();
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
      throw new Exception(
          "Incorrect EPUB navigation point: point ID is missing.");
    }

    result.NavigationLabels = new List<EpubNavigationLabel>();
    result.ChildNavigationPoints = new List<EpubNavigationPoint>();
    navigationPointNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
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

    if (!(result.NavigationLabels.length > 0)) {
      throw new Exception(
          "EPUB parsing error: navigation point ${result.Id} should contain at least one navigation label.");
    }
    if (result.Content == null) {
      throw new Exception(
          "EPUB parsing error: navigation point ${result.Id} should contain content.");
    }

    return result;
  }

  static EpubNavigationLabel readNavigationLabel(
      xml.XmlElement navigationLabelNode) {
    EpubNavigationLabel result = new EpubNavigationLabel();

    xml.XmlElement navigationLabelTextNode = navigationLabelNode
        .findElements("text", namespace: navigationLabelNode.name.namespaceUri)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (navigationLabelTextNode == null) {
      throw new Exception(
          "Incorrect EPUB navigation label: label text element is missing.");
    }

    result.Text = navigationLabelTextNode.text;

    return result;
  }

  static EpubNavigationContent readNavigationContent(
      xml.XmlElement navigationContentNode) {
    EpubNavigationContent result = new EpubNavigationContent();
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
      throw new Exception(
          "Incorrect EPUB navigation content: content source is missing.");
    }

    return result;
  }

  static EpubNavigationPageList readNavigationPageList(
      xml.XmlElement navigationPageListNode) {
    EpubNavigationPageList result = new EpubNavigationPageList();
    result.Targets = new List<EpubNavigationPageTarget>();
    navigationPageListNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
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
    EpubNavigationPageTarget result = new EpubNavigationPageTarget();
    result.NavigationLabels = new List<EpubNavigationLabel>();
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
          var converter = new EnumFromString<EpubNavigationPageTargetType>(
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
      throw new Exception(
          "Incorrect EPUB navigation page target: page target type is missing.");
    }

    navigationPageTargetNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
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
    if (result.NavigationLabels.length == 0) {
      throw new Exception(
          "Incorrect EPUB navigation page target: at least one navLabel element is required.");
    }

    return result;
  }

  static EpubNavigationList readNavigationList(
      xml.XmlElement navigationListNode) {
    EpubNavigationList result = new EpubNavigationList();
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
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
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
    if (result.NavigationLabels.length == 0) {
      throw new Exception(
          "Incorrect EPUB navigation page target: at least one navLabel element is required.");
    }
    return result;
  }

  static EpubNavigationTarget readNavigationTarget(
      xml.XmlElement navigationTargetNode) {
    EpubNavigationTarget result = new EpubNavigationTarget();
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
      throw new Exception(
          "Incorrect EPUB navigation target: navigation target ID is missing.");
    }

    navigationTargetNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
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
    if (result.NavigationLabels.length == 0) {
      throw new Exception(
          "Incorrect EPUB navigation target: at least one navLabel element is required.");
    }

    return result;
  }
}
