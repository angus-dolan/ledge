import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ledge/model/coinDetailedModel.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:http/http.dart' as http;

class CoinsApi {
  static Future<List<Coin>> searchCoins(String query) async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc&per_page=100&page=1&sparkline=false%22');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List coins = json.decode(response.body);

      return coins.map((json) => Coin.fromJson(json)).where((coin) {
        final nameLower = coin.name.toLowerCase();
        final symbolLower = coin.symbol.toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) ||
            symbolLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<Coin>> getCoins() async {
    final url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc&per_page=100&page=1&sparkline=false%22';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    String responseString = response.body.toString().replaceAll("\n", "");
    final body = jsonDecode(responseString);

    return body.map<Coin>(Coin.fromJson).toList();
  }

  static Future<Coin> getCoin(id) async {
    final url = 'https://api.coingecko.com/api/v3/coins/' + id;
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = json.decode(response.body);

    Coin coin = new Coin(
        id: body['id'],
        name: body['name'],
        symbol: body['symbol'],
        currentPrice: body['market_data']['current_price']['gbp'].toString(),
        img: body['image']['large']);

    return coin;
  }

  static Future<CoinDetailed> getCoinDetailed(id) async {
    final url = 'https://api.coingecko.com/api/v3/coins/' + id;
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = json.decode(response.body);

    CoinDetailed coin = CoinDetailed.fromJson(body);

    return coin;
  }
}
