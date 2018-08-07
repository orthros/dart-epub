import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

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

  @override
  int get hashCode => hashObjects([
        Titles.hashCode,
        Creators.hashCode,
        Subjects.hashCode,
        Description.hashCode,
        Publishers.hashCode,
        Contributors.hashCode,
        Dates.hashCode,
        Types.hashCode,
        Formats.hashCode,
        Identifiers.hashCode,
        Sources.hashCode,
        Languages.hashCode,
        Relations.hashCode,
        Coverages.hashCode,
        Rights.hashCode,
        MetaItems.hashCode
      ]);

  bool operator ==(other) {
    var otherAs = other as EpubMetadata;
    if (otherAs == null) return false;
    if (Description != otherAs.Description) return false;

    if (!collections.listsEqual(Titles, otherAs.Titles) ||
        !collections.listsEqual(Creators, otherAs.Creators) ||
        !collections.listsEqual(Subjects, otherAs.Subjects) ||
        !collections.listsEqual(Publishers, otherAs.Publishers) ||
        !collections.listsEqual(Contributors, otherAs.Contributors) ||
        !collections.listsEqual(Dates, otherAs.Dates) ||
        !collections.listsEqual(Types, otherAs.Types) ||
        !collections.listsEqual(Formats, otherAs.Formats) ||
        !collections.listsEqual(Identifiers, otherAs.Identifiers) ||
        !collections.listsEqual(Sources, otherAs.Sources) ||
        !collections.listsEqual(Languages, otherAs.Languages) ||
        !collections.listsEqual(Relations, otherAs.Relations) ||
        !collections.listsEqual(Coverages, otherAs.Coverages) ||
        !collections.listsEqual(Rights, other.Rights) ||
        !collections.listsEqual(MetaItems, other.MetaItems)) {
      return false;
    }

    return true;
  }
}
