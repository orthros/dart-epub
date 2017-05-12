import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  Map<String, EpubTextContentFileRef> Html;
  Map<String, EpubTextContentFileRef> Css;
  Map<String, EpubByteContentFileRef> Images;
  Map<String, EpubByteContentFileRef> Fonts;
  Map<String, EpubContentFileRef> AllFiles;
}
