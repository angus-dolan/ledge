import 'package:meta/meta.dart';

class Coin {
  final String id;
  final String name;
  final String symbol;
  final String currentPrice;
  final String img;

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.img,
  });

  static Coin fromJson(json) => Coin(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        currentPrice: json['current_price'].toString(),
        img: json['image'],
      );
}
