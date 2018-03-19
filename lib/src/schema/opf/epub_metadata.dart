import 'epub_metadata_contributor.dart';
import 'epub_metadata_creator.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';

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
