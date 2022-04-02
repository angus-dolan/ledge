import 'package:meta/meta.dart';

class CoinDetailed {
  final String id;
  final String name;
  final String symbol;
  final String currentPrice;
  final String img;
  final String description;
  final String rank;
  final List website;
  final String genesisDate;

  const CoinDetailed({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.img,
    required this.description,
    required this.rank,
    required this.website,
    required this.genesisDate,
  });

  static CoinDetailed fromJson(json) => CoinDetailed(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        currentPrice: json['market_data']['current_price']['gbp'].toString(),
        img: json['image']['large'],
        description: json['description']['en'],
        rank: json['market_cap_rank'].toString(),
        website: json['links']['homepage'],
        genesisDate: json['genesis_date'].toString(),
      );
}
