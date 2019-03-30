import 'package:epub/src/schema/opf/epub_spine.dart';
import 'package:xml/xml.dart';

class EpubSpineWriter {
  static void writeSpine(XmlBuilder builder, EpubSpine spine) {
    builder
      ..element("spine", attributes: {"toc": spine.TableOfContents}, nest: () {
        spine.Items.forEach((spineitem) => builder.element("itemref",
                attributes: {
                  "idref": spineitem.IdRef,
                  "linear": spineitem.IsLinear ? "no" : "yes"
                }));
      });
  }
}
