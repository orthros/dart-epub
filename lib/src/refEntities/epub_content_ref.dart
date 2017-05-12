import 'epubByteContentFileRef.dart';
import 'epubContentFileRef.dart';
import 'epubTextContentFileRef.dart';

class EpubContentRef {
  Map<String, EpubTextContentFileRef> Html;
  Map<String, EpubTextContentFileRef> Css;
  Map<String, EpubByteContentFileRef> Images;
  Map<String, EpubByteContentFileRef> Fonts;
  Map<String, EpubContentFileRef> AllFiles;
}