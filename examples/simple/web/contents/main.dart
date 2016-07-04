import 'dart:html';

main() {
  var message = new ParagraphElement()..text = "hello from dartland";
  document.body.children.add(message);
}
