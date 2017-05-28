# dart-epub
[![Build Status](https://travis-ci.org/orthros/dart-epub.svg?branch=master)](https://travis-ci.org/orthros/dart-epub)

Epub Reader for Dart inspired by [this fantastic C# Epub Reader](https://github.com/versfx/EpubReader)

This does not rely on the ```dart:io``` package in any way, so it is avilable for both desktop and web-based implementations

## Installing
Add the package to the ```dependencies``` section of your pubspec.yaml
```
dependencies:
  epub: ^1.2.0
```

## Example
```dart

//Get the epub into memory somehow
String fileName = "hittelOnGoldMines.epub";
String fullPath = path.join(io.Directory.current.path, fileName);
var targetFile = new io.File(fullPath);
List<int> bytes = await targetFile.readAsBytes();


// Opens a book and reads all of its content into the memory
EpubBook epubBook = await EpubReader.readBook(bytes);
            
// COMMON PROPERTIES

// Book's title
String title = epubBook.Title;

// Book's authors (comma separated list)
String author = epubBook.Author;

// Book's authors (list of authors names)
List<String> authors = epubBook.AuthorList;

// Book's cover image (null if there is no cover)
Image coverImage = epubBook.CoverImage;

            
// CHAPTERS

// Enumerating chapters
epubBook.Chapters.forEach((EpubChapter chapter) {
  // Title of chapter
  String chapterTitle = chapter.Title;
              
  // HTML content of current chapter
  String chapterHtmlContent = chapter.HtmlContent;

  // Nested chapters
  List<EpubChapter> subChapters = chapter.SubChapters;
});

            
// CONTENT

// Book's content (HTML files, stlylesheets, images, fonts, etc.)
EpubContent bookContent = epubBook.Content;

            
// IMAGES

// All images in the book (file name is the key)
Map<String, EpubByteContentFile> images = bookContent.Images;

EpubByteContentFile firstImage = images.values.first;

// Content type (e.g. EpubContentType.IMAGE_JPEG, EpubContentType.IMAGE_PNG)
EpubContentType contentType = firstImage.ContentType;

// MIME type (e.g. "image/jpeg", "image/png")
String mimeContentType = firstImage.ContentMimeType;

// HTML & CSS

// All XHTML files in the book (file name is the key)
Map<String, EpubTextContentFile> htmlFiles = bookContent.Html;

// All CSS files in the book (file name is the key)
Map<String, EpubTextContentFile> cssFiles = bookContent.Css;

// Entire HTML content of the book
htmlFiles.values.forEach((EpubTextContentFile htmlFile) {
  String htmlContent = htmlFile.Content;
});

// All CSS content in the book
cssFiles.values.forEach((EpubTextContentFile cssFile){
  String cssContent = cssFile.Content;
});


// OTHER CONTENT

// All fonts in the book (file name is the key)
Map<String, EpubByteContentFile> fonts = bookContent.Fonts;

// All files in the book (including HTML, CSS, images, fonts, and other types of files)
Map<String, EpubContentFile> allFiles = bookContent.AllFiles;


// ACCESSING RAW SCHEMA INFORMATION

// EPUB OPF data
EpubPackage package = epubBook.Schema.Package;

// Enumerating book's contributors
package.Metadata.Contributors.forEach((EpubMetadataContributor contributor){
  String contributorName = contributor.Contributor;
  String contributorRole = contributor.Role;
});

// EPUB NCX data
EpubNavigation navigation = epubBook.Schema.Navigation;

// Enumerating NCX metadata
navigation.Head.Metadata.forEach((EpubNavigationHeadMeta meta){
  String metadataItemName = meta.Name;
  String metadataItemContent = meta.Content;
});
```