import 'dart:async';

import 'package:image/image.dart' as images;

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  static Future<images.Image> readBookCover(EpubBookRef bookRef) async {
    List<EpubMetadataMeta> metaItems =
        bookRef.Schema.Package.Metadata.MetaItems;
    if (metaItems == null || metaItems.length == 0) return null;

    EpubMetadataMeta coverMetaItem = metaItems.firstWhere(
        (EpubMetadataMeta metaItem) =>
            metaItem.Name != null && metaItem.Name.toLowerCase() == "cover",
        orElse: () => null);
    if (coverMetaItem == null) return null;
    if (coverMetaItem.Content == null || coverMetaItem.Content.isEmpty)
      throw new Exception(
          "Incorrect EPUB metadata: cover item content is missing.");

    EpubManifestItem coverManifestItem = bookRef.Schema.Package.Manifest.Items
        .firstWhere(
            (EpubManifestItem manifestItem) =>
                manifestItem.Id.toLowerCase() ==
                coverMetaItem.Content.toLowerCase(),
            orElse: () => null);
    if (coverManifestItem == null)
      throw new Exception(
          "Incorrect EPUB manifest: item with ID = \"${coverMetaItem.Content}\" is missing.");

    EpubByteContentFileRef coverImageContentFileRef;
    if (!bookRef.Content.Images.containsKey(coverManifestItem.Href))
      throw new Exception(
          "Incorrect EPUB manifest: item with href = \"${coverManifestItem.Href}\" is missing.");

    coverImageContentFileRef = bookRef.Content.Images[coverManifestItem.Href];
    List<int> coverImageContent =
        await coverImageContentFileRef.readContentAsBytes();
    images.Image retval = images.decodeImage(coverImageContent);
    return retval;
  }
}
