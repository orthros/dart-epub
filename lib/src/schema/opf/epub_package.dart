import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage {
  EpubVersion Version;
  EpubMetadata Metadata;
  EpubManifest Manifest;
  EpubSpine Spine;
  EpubGuide Guide;
}
