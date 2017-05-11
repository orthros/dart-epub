import 'dart:async';

import '../refEntities/epubBookRef.dart';
import '../refEntities/epubByteContentFileRef.dart';
import '../schema/opf/epubManifestItem.dart';
import '../schema/opf/epubMetadataMeta.dart';

import 'package:image/image.dart' as images;

class BookCoverReader {
  static Future<images.Image> ReadBookCoverAsync(EpubBookRef bookRef) async {
    List<EpubMetadataMeta> metaItems = bookRef.Schema.Package.Metadata.MetaItems;
    if (metaItems == null || metaItems.length == 0)
      return null;
    EpubMetadataMeta coverMetaItem = metaItems.firstWhere((EpubMetadataMeta metaItem) => metaItem.Name.toLowerCase() == "cover", orElse: () => null);
    if (coverMetaItem == null)
      return null;
    if (coverMetaItem.Content == null || coverMetaItem.Content.isEmpty)
      throw new Exception("Incorrect EPUB metadata: cover item content is missing.");
    EpubManifestItem coverManifestItem = bookRef.Schema
                                                .Package
                                                .Manifest
                                                .Items
                                                .firstWhere((EpubManifestItem manifestItem) => manifestItem.Id.toLowerCase() == coverMetaItem.Content.toLowerCase(), orElse: () => null));
    if (coverManifestItem == null)
      throw new Exception("Incorrect EPUB manifest: item with ID = \"${coverMetaItem.Content}\" is missing.");
    EpubByteContentFileRef coverImageContentFileRef;
    if (!bookRef.Content.Images.containsKey(coverManifestItem.Href))
      throw new Exception("Incorrect EPUB manifest: item with href = \"${coverManifestItem.Href}\" is missing.");
    coverImageContentFileRef = bookRef.Content.Images[coverManifestItem.Href];
    List<int> coverImageContent = await coverImageContentFileRef.ReadContentAsBytesAsync();
    images.Image retval  = images.decodeImage(coverImageContent);
    return retval;
  }
}