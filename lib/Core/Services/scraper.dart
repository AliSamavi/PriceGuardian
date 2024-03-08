import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class Scraper {
  late String url;
  late String S1;
  late String S2;

  Scraper(this.url, this.S1, this.S2);

  Future<Element> _getSoup() async {
    var response = await http.get(Uri.parse(url));
    return html.parse(response.body).documentElement!;
  }

  Future<String> getPrice() async {
    Element soup = await _getSoup();
    RegExp regex = RegExp(r'\d+');
    late String price;
    Element? A1 = soup.querySelector(S1);
    Element? A2 = soup.querySelector(S2);
    if (A1 != null) {
      if (A1.text.isEmpty) {
        price = A1.attributes["content"]!;
      } else {
        regex.allMatches(A1.text.replaceAll(",", "")).forEach((element) {
          price = element.group(0)!;
        });
      }
    } else if (A2 != null) {
      if (A2.attributes.containsKey("content")) {
        price = A2.attributes["content"]!;
      } else {
        regex.allMatches(A2.text.replaceAll(",", "")).forEach((element) {
          price = element.group(0)!;
        });
      }
    } else {
      price = "";
    }

    return price;
  }
}
