import 'package:PriceGuardian/Core/Utils/currency.dart';

class Converters {
  static String number(String number) {
    final Map<String, String> englishDigits = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    String result = number;
    englishDigits.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String currency(
    String price,
    String myCurrency,
    String priceCurrency,
  ) {
    if (myCurrency == priceCurrency) {
      return price;
    } else if (myCurrency == Currency.rial.toString() &&
        priceCurrency == Currency.toman.toString()) {
      return "${price}0";
    } else if (myCurrency == Currency.toman.toString() &&
        priceCurrency == Currency.rial.toString()) {
      return price.substring(0, price.length - 1);
    } else {
      return "";
    }
  }

  static String calculator(String price, double percent) {
    double amount = percent / 100;
    return (int.parse(price) * amount).toString();
  }
}
