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
  int get hashCode {
    var objects = []
      ..addAll(Titles.map((title) => title.hashCode))
      ..addAll(Creators.map((creator) => creator.hashCode))
      ..addAll(Subjects.map((subject) => subject.hashCode))
      ..addAll(Publishers.map((publisher) => publisher.hashCode))
      ..addAll(Contributors.map((contributor) => contributor.hashCode))
      ..addAll(Dates.map((date) => date.hashCode))
      ..addAll(Types.map((type) => type.hashCode))
      ..addAll(Formats.map((format) => format.hashCode))
      ..addAll(Identifiers.map((identifier) => identifier.hashCode))
      ..addAll(Sources.map((source) => source.hashCode))
      ..addAll(Languages.map((language) => language.hashCode))
      ..addAll(Relations.map((relation) => relation.hashCode))
      ..addAll(Coverages.map((coverage) => coverage.hashCode))
      ..addAll(Rights.map((right) => right.hashCode))
      ..addAll(MetaItems.map((metaItem) => metaItem.hashCode))
      ..add(Description.hashCode);

    return hashObjects(objects);
  }

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
