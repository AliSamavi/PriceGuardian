import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class Service {
  static void put(
    String domain,
    Map<String, String> headers,
    int id,
    String price,
  ) async {
    Uri url = Uri.parse("https://$domain/api/products/$id");
    try {
      final response = await http.get(url, headers: headers);

      final document = XmlDocument.parse(response.body);

      final product = document.rootElement.findElements("product").first;

      product.findElements("manufacturer_name").first.remove();
      product.findElements("quantity").first.remove();
      product.findElements("price").first.innerText = price;

      final body = document.toXmlString();

      http.put(url, body: body, headers: headers).then((result) {
        print(result.statusCode);
      });
    } catch (e) {}
  }
}
