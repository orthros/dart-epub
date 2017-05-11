library epubtest;

import 'package:test/test.dart';
import 'package:epub/epub.dart';

main() {  
  test("Enum", () {  
   expect( new EnumFromString<Simple>().get("ONE"), equals(Simple.ONE));  
  });  
 }  

 enum Simple {
   ONE,
   TWO,
   THREE
 }