import 'epubByteContentFile.dart';
import 'epubContentFile.dart';
import 'epubTextContentFile.dart';

class EpubContent{
    Map<String, EpubTextContentFile> Html;
    Map<String, EpubTextContentFile> Css;
    Map<String, EpubByteContentFile> Images;
    Map<String, EpubByteContentFile> Fonts;
    Map<String, EpubContentFile> AllFiles;
}