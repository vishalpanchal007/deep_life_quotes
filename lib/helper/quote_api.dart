import 'dart:convert';
import 'package:deep_life_quotes/modal/quote_modal.dart';
import 'package:http/http.dart' as http;

class QuotesAPIHelper {
  QuotesAPIHelper._();

  static final QuotesAPIHelper quotesAPIHelper = QuotesAPIHelper._();

  Future<List<Quotes>?> fetchQuotes() async {
    http.Response response = await http.get(
      Uri.parse("https://api.quotable.io/quotes?maxLength=50"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(response.body);

      List<dynamic> data = decodedData["results"];

      List<Quotes> myQuotes = data.map((e) => Quotes.fromMap(data: e)).toList();


      return myQuotes;
    }
    return null;
  }
}
