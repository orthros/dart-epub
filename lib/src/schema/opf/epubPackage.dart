import 'epubManifest.dart';
import 'epubVersion.dart';
import 'epubMetadata.dart';
import 'epubSpine.dart';
import 'epubGuide.dart';

class EpubPackage {
  EpubVersion EpubVersion;
  EpubMetadata Metadata;
  EpubManifest Manifest;
  EpubSpine Spine;
  EpubGuide Guide;
}