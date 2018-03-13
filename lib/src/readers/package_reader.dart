import 'dart:async';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';
import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_creator.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';

class PackageReader {
  static Future<EpubPackage> readPackage(
      Archive epubArchive, String rootFilePath) async {
    ArchiveFile rootFileEntry = epubArchive.files.firstWhere(
        (ArchiveFile testfile) => testfile.name == rootFilePath,
        orElse: () => null);
    if (rootFileEntry == null)
      throw new Exception(
          "EPUB parsing error: root file not found in archive.");
    xml.XmlDocument containerDocument =
        xml.parse(utf8.decode(rootFileEntry.content));
    String opfNamespace = "http://www.idpf.org/2007/opf";
    xml.XmlElement packageNode = containerDocument
        .findElements("package", namespace: opfNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null);
    EpubPackage result = new EpubPackage();
    String epubVersionValue = packageNode.getAttribute("version");
    if (epubVersionValue == "2.0")
      result.Version = EpubVersion.Epub2;
    else if (epubVersionValue == "3.0")
      result.Version = EpubVersion.Epub3;
    else
      throw new Exception("Unsupported EPUB version: ${epubVersionValue}.");
    xml.XmlElement metadataNode = packageNode
        .findElements("metadata", namespace: opfNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null);
    if (metadataNode == null)
      throw new Exception(
          "EPUB parsing error: metadata not found in the package.");
    EpubMetadata metadata = readMetadata(metadataNode, result.Version);
    result.Metadata = metadata;
    xml.XmlElement manifestNode = packageNode
        .findElements("manifest", namespace: opfNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null);
    if (manifestNode == null)
      throw new Exception(
          "EPUB parsing error: manifest not found in the package.");
    EpubManifest manifest = readManifest(manifestNode);
    result.Manifest = manifest;

    xml.XmlElement spineNode = packageNode
        .findElements("spine", namespace: opfNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null);
    if (spineNode == null)
      throw new Exception(
          "EPUB parsing error: spine not found in the package.");
    EpubSpine spine = readSpine(spineNode);
    result.Spine = spine;
    xml.XmlElement guideNode = packageNode
        .findElements("guide", namespace: opfNamespace)
        .firstWhere((xml.XmlElement elem) => elem != null, orElse: () => null);
    if (guideNode != null) {
      EpubGuide guide = readGuide(guideNode);
      result.Guide = guide;
    }
    return result;
  }

  static EpubMetadata readMetadata(
      xml.XmlElement metadataNode, EpubVersion epubVersion) {
    EpubMetadata result = new EpubMetadata();
    result.Titles = new List<String>();
    result.Creators = new List<EpubMetadataCreator>();
    result.Subjects = new List<String>();
    result.Publishers = new List<String>();
    result.Contributors = new List<EpubMetadataContributor>();
    result.Dates = new List<EpubMetadataDate>();
    result.Types = new List<String>();
    result.Formats = new List<String>();
    result.Identifiers = new List<EpubMetadataIdentifier>();
    result.Sources = new List<String>();
    result.Languages = new List<String>();
    result.Relations = new List<String>();
    result.Coverages = new List<String>();
    result.Rights = new List<String>();
    result.MetaItems = new List<EpubMetadataMeta>();
    metadataNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement metadataItemNode) {
      String innerText = metadataItemNode.text;
      switch (metadataItemNode.name.local.toLowerCase()) {
        case "title":
          result.Titles.add(innerText);
          break;
        case "creator":
          EpubMetadataCreator creator = readMetadataCreator(metadataItemNode);
          result.Creators.add(creator);
          break;
        case "subject":
          result.Subjects.add(innerText);
          break;
        case "description":
          result.Description = innerText;
          break;
        case "publisher":
          result.Publishers.add(innerText);
          break;
        case "contributor":
          EpubMetadataContributor contributor =
              readMetadataContributor(metadataItemNode);
          result.Contributors.add(contributor);
          break;
        case "date":
          EpubMetadataDate date = readMetadataDate(metadataItemNode);
          result.Dates.add(date);
          break;
        case "type":
          result.Types.add(innerText);
          break;
        case "format":
          result.Formats.add(innerText);
          break;
        case "identifier":
          EpubMetadataIdentifier identifier =
              readMetadataIdentifier(metadataItemNode);
          result.Identifiers.add(identifier);
          break;
        case "source":
          result.Sources.add(innerText);
          break;
        case "language":
          result.Languages.add(innerText);
          break;
        case "relation":
          result.Relations.add(innerText);
          break;
        case "coverage":
          result.Coverages.add(innerText);
          break;
        case "rights":
          result.Rights.add(innerText);
          break;
        case "meta":
          if (epubVersion == EpubVersion.Epub2) {
            EpubMetadataMeta meta = readMetadataMetaVersion2(metadataItemNode);
            result.MetaItems.add(meta);
          } else if (epubVersion == EpubVersion.Epub3) {
            EpubMetadataMeta meta = readMetadataMetaVersion3(metadataItemNode);
            result.MetaItems.add(meta);
          }
          break;
      }
    });
    return result;
  }

  static EpubMetadataCreator readMetadataCreator(
      xml.XmlElement metadataCreatorNode) {
    EpubMetadataCreator result = new EpubMetadataCreator();
    metadataCreatorNode.attributes
        .forEach((xml.XmlAttribute metadataCreatorNodeAttribute) {
      String attributeValue = metadataCreatorNodeAttribute.value;
      switch (metadataCreatorNodeAttribute.name.local.toLowerCase()) {
        case "role":
          result.Role = attributeValue;
          break;
        case "file-as":
          result.FileAs = attributeValue;
          break;
      }
    });
    result.Creator = metadataCreatorNode.text;
    return result;
  }

  static EpubMetadataContributor readMetadataContributor(
      xml.XmlElement metadataContributorNode) {
    EpubMetadataContributor result = new EpubMetadataContributor();
    metadataContributorNode.attributes
        .forEach((xml.XmlAttribute metadataContributorNodeAttribute) {
      String attributeValue = metadataContributorNodeAttribute.value;
      switch (metadataContributorNodeAttribute.name.local.toLowerCase()) {
        case "role":
          result.Role = attributeValue;
          break;
        case "file-as":
          result.FileAs = attributeValue;
          break;
      }
    });
    result.Contributor = metadataContributorNode.text;
    return result;
  }

  static EpubMetadataDate readMetadataDate(xml.XmlElement metadataDateNode) {
    EpubMetadataDate result = new EpubMetadataDate();
    String eventAttribute = metadataDateNode.getAttribute("event",
        namespace: metadataDateNode.name.namespaceUri);
    if (eventAttribute != null && !eventAttribute.isEmpty)
      result.Event = eventAttribute;
    result.Date = metadataDateNode.text;
    return result;
  }

  static EpubMetadataIdentifier readMetadataIdentifier(
      xml.XmlElement metadataIdentifierNode) {
    EpubMetadataIdentifier result = new EpubMetadataIdentifier();
    metadataIdentifierNode.attributes
        .forEach((xml.XmlAttribute metadataIdentifierNodeAttribute) {
      String attributeValue = metadataIdentifierNodeAttribute.value;
      switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "opf:scheme":
          result.Scheme = attributeValue;
          break;
      }
    });
    result.Identifier = metadataIdentifierNode.text;
    return result;
  }

  static EpubMetadataMeta readMetadataMetaVersion2(
      xml.XmlElement metadataMetaNode) {
    EpubMetadataMeta result = new EpubMetadataMeta();
    metadataMetaNode.attributes
        .forEach((xml.XmlAttribute metadataMetaNodeAttribute) {
      String attributeValue = metadataMetaNodeAttribute.value;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case "name":
          result.Name = attributeValue;
          break;
        case "content":
          result.Content = attributeValue;
          break;
      }
    });
    return result;
  }

  static EpubMetadataMeta readMetadataMetaVersion3(
      xml.XmlElement metadataMetaNode) {
    EpubMetadataMeta result = new EpubMetadataMeta();
    metadataMetaNode.attributes
        .forEach((xml.XmlAttribute metadataMetaNodeAttribute) {
      String attributeValue = metadataMetaNodeAttribute.value;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case "id":
          result.Id = attributeValue;
          break;
        case "refines":
          result.Refines = attributeValue;
          break;
        case "property":
          result.Property = attributeValue;
          break;
        case "scheme":
          result.Scheme = attributeValue;
          break;
      }
    });
    result.Content = metadataMetaNode.text;
    return result;
  }

  static EpubManifest readManifest(xml.XmlElement manifestNode) {
    EpubManifest result = new EpubManifest();
    result.Items = new List<EpubManifestItem>();
    manifestNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == "item") {
        EpubManifestItem manifestItem = new EpubManifestItem();
        manifestItemNode.attributes
            .forEach((xml.XmlAttribute manifestItemNodeAttribute) {
          String attributeValue = manifestItemNodeAttribute.value;
          switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
            case "id":
              manifestItem.Id = attributeValue;
              break;
            case "href":
              manifestItem.Href = attributeValue;
              break;
            case "media-type":
              manifestItem.MediaType = attributeValue;
              break;
            case "required-namespace":
              manifestItem.RequiredNamespace = attributeValue;
              break;
            case "required-modules":
              manifestItem.RequiredModules = attributeValue;
              break;
            case "fallback":
              manifestItem.Fallback = attributeValue;
              break;
            case "fallback-style":
              manifestItem.FallbackStyle = attributeValue;
              break;
          }
        });

        if (manifestItem.Id == null || manifestItem.Id.isEmpty)
          throw new Exception("Incorrect EPUB manifest: item ID is missing");
        if (manifestItem.Href == null || manifestItem.Href.isEmpty)
          throw new Exception("Incorrect EPUB manifest: item href is missing");
        if (manifestItem.MediaType == null || manifestItem.MediaType.isEmpty)
          throw new Exception(
              "Incorrect EPUB manifest: item media type is missing");
        result.Items.add(manifestItem);
      }
    });
    return result;
  }

  static EpubSpine readSpine(xml.XmlElement spineNode) {
    EpubSpine result = new EpubSpine();
    result.Items = new List<EpubSpineItemRef>();
    String tocAttribute = spineNode.getAttribute("toc");
    if (tocAttribute == null || tocAttribute.isEmpty)
      throw new Exception("Incorrect EPUB spine: TOC is missing");
    result.TableOfContents = tocAttribute;
    spineNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == "itemref") {
        EpubSpineItemRef spineItemRef = new EpubSpineItemRef();
        String idRefAttribute = spineItemNode.getAttribute("idref");
        if (idRefAttribute == null || idRefAttribute.isEmpty)
          throw new Exception("Incorrect EPUB spine: item ID ref is missing");
        spineItemRef.IdRef = idRefAttribute;
        String linearAttribute = spineItemNode.getAttribute("linear");
        spineItemRef.IsLinear =
            linearAttribute == null || (linearAttribute.toLowerCase() == "no");
        result.Items.add(spineItemRef);
      }
    });
    return result;
  }

  static EpubGuide readGuide(xml.XmlElement guideNode) {
    EpubGuide result = new EpubGuide();
    result.Items = new List<EpubGuideReference>();
    guideNode.children
        .where((xml.XmlNode node) => node is xml.XmlElement)
        .map((xml.XmlNode node) => node as xml.XmlElement)
        .forEach((xml.XmlElement guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == "reference") {
        EpubGuideReference guideReference = new EpubGuideReference();
        guideReferenceNode.attributes
            .forEach((xml.XmlAttribute guideReferenceNodeAttribute) {
          String attributeValue = guideReferenceNodeAttribute.value;
          switch (guideReferenceNodeAttribute.name.local.toLowerCase()) {
            case "type":
              guideReference.Type = attributeValue;
              break;
            case "title":
              guideReference.Title = attributeValue;
              break;
            case "href":
              guideReference.Href = attributeValue;
              break;
          }
        });
        if (guideReference.Type == null || guideReference.Type.isEmpty)
          throw new Exception("Incorrect EPUB guide: item type is missing");
        if (guideReference.Href == null || guideReference.Href.isEmpty)
          throw new Exception("Incorrect EPUB guide: item href is missing");
        result.Items.add(guideReference);
      }
    });
    return result;
  }
}
