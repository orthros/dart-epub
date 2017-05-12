import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent {
  Map<String, EpubTextContentFile> Html;
  Map<String, EpubTextContentFile> Css;
  Map<String, EpubByteContentFile> Images;
  Map<String, EpubByteContentFile> Fonts;
  Map<String, EpubContentFile> AllFiles;
}
