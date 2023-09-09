import 'dart:developer';
import 'package:deep_life_quotes/helper/quote_api.dart';
import 'package:deep_life_quotes/helper/quote_db.dart';
import 'package:deep_life_quotes/modal/quote_modal.dart';
import 'package:deep_life_quotes/screen/detail_page.dart';
import 'package:deep_life_quotes/screen/image_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deep_life_quotes/global.dart';
import 'screen/home.dart';

bool connection = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prep = await SharedPreferences.getInstance();

  connection = await InternetConnectionChecker().hasConnection;

  log(connection.toString(), name: "Connection");
  global.isData = prep.getBool('isData') ?? false;
  prep.setBool('isData', global.isData);

  if (connection == true) {
    await QuoteDatabaseHelper.quoteDatabaseHelper.deleteAllData();

    List<Quotes>? allQuotes =
    await QuotesAPIHelper.quotesAPIHelper.fetchQuotes();

    await QuoteDatabaseHelper.quoteDatabaseHelper
        .insertData(allQuotes: allQuotes);
  } else {
    List<Quotes> quotes =
    await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();

    log(quotes.toString(), name: "Quotes");
  }

  List<String> quotes = [];
  quoteData() async {
    List<Quotes> data =
    await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      global.quotes.add(data[i].quote);
    }
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => home(),
        'detail_Page': (context) => detail_page(),
        'image_detail_page': (context) => image_detail_page(),
      },
    ),
  );
}
