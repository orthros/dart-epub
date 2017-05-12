import 'epubMetadataContributor.dart';
import 'epubMetadataCreator.dart';
import 'epubMetadataDate.dart';
import 'epubMetadataIdentifier.dart';
import 'epubMetadataMeta.dart';

class EpubMetadata {
  List<String> Titles;
  List<EpubMetadataCreator> Creators;
  List<String> Subjects;
  String Description;
  List<String> Publishers;
  List<EpubMetadataContributor> Contributors;
  List<EpubMetadataDate> Dates;
  List<String> Types;
  List<String> Formats;
  List<EpubMetadataIdentifier> Identifiers;
  List<String> Sources;
  List<String> Languages;
  List<String> Relations;
  List<String> Coverages;
  List<String> Rights;
  List<EpubMetadataMeta> MetaItems;  
}