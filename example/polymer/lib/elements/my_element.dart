@HtmlImport('my_element.html')
library my_element;

import 'dart:html';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

//ignore: unused_import
import 'package:polymer_elements/google_map.dart';

@PolymerRegister(MyElement.tag)
class MyElement extends PolymerElement {
  static const String tag = 'my-element';
  
  MyElement.created() : super.created();
  
  factory MyElement() => new Element.tag(MyElement.tag);
}
