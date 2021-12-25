class CoinQuote {
  late String id;
  late String name;
  late String symbol;
  late int rank;
  late int circulatingSupply;
  late int totalSupply;
  late int maxSupply;
  late double betaValue;
  late String firstDataAt;
  late String lastUpdated;
  late Quotes quotes;

  CoinQuote(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.rank,
      required this.circulatingSupply,
      required this.totalSupply,
      required this.maxSupply,
      required this.betaValue,
      required this.firstDataAt,
      required this.lastUpdated,
      required this.quotes});

  CoinQuote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    rank = json['rank'];
    circulatingSupply = json['circulating_supply'];
    totalSupply = json['total_supply'];
    maxSupply = json['max_supply'];
    betaValue = json['beta_value'];
    firstDataAt = json['first_data_at'];
    lastUpdated = json['last_updated'];
    quotes =
        (json['quotes'] != null ? new Quotes.fromJson(json['quotes']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['rank'] = this.rank;
    data['circulating_supply'] = this.circulatingSupply;
    data['total_supply'] = this.totalSupply;
    data['max_supply'] = this.maxSupply;
    data['beta_value'] = this.betaValue;
    data['first_data_at'] = this.firstDataAt;
    data['last_updated'] = this.lastUpdated;
    if (this.quotes != null) {
      data['quotes'] = this.quotes.toJson();
    }
    return data;
  }
}

class Quotes {
  late USD uSD;

  Quotes({required this.uSD});

  Quotes.fromJson(Map<String, dynamic> json) {
    uSD = (json['USD'] != null ? new USD.fromJson(json['USD']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uSD != null) {
      data['USD'] = this.uSD.toJson();
    }
    return data;
  }
}

class USD {
  late double price;
  late double volume24h;
  late double volume24hChange24h;
  late int marketCap;
  late int marketCapChange24h;
  late double percentChange15m;
  late double percentChange30m;
  late double percentChange1h;
  late double percentChange6h;
  late double percentChange12h;
  late double percentChange24h;
  late double percentChange7d;
  late double percentChange30d;
  late int percentChange1y;
  late double athPrice;
  late String athDate;
  late double percentFromPriceAth;

  USD(
      {
        required this.price,
      required this.volume24h,
      required this.volume24hChange24h,
      required this.marketCap,
      required this.marketCapChange24h,
      required this.percentChange15m,
      required this.percentChange30m,
      required this.percentChange1h,
      required this.percentChange6h,
      required this.percentChange12h,
      required this.percentChange24h,
      required this.percentChange7d,
      required this.percentChange30d,
      required this.percentChange1y,
      required this.athPrice,
      required this.athDate,
      required this.percentFromPriceAth});

  USD.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    volume24h = json['volume_24h'];
    volume24hChange24h = json['volume_24h_change_24h'];
    marketCap = json['market_cap'];
    marketCapChange24h = json['market_cap_change_24h'];
    percentChange15m = json['percent_change_15m'];
    percentChange30m = json['percent_change_30m'];
    percentChange1h = json['percent_change_1h'];
    percentChange6h = json['percent_change_6h'];
    percentChange12h = json['percent_change_12h'];
    percentChange24h = json['percent_change_24h'];
    percentChange7d = json['percent_change_7d'];
    percentChange30d = json['percent_change_30d'];
    percentChange1y = json['percent_change_1y'];
    athPrice = json['ath_price'];
    athDate = json['ath_date'];
    percentFromPriceAth = json['percent_from_price_ath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['volume_24h'] = this.volume24h;
    data['volume_24h_change_24h'] = this.volume24hChange24h;
    data['market_cap'] = this.marketCap;
    data['market_cap_change_24h'] = this.marketCapChange24h;
    data['percent_change_15m'] = this.percentChange15m;
    data['percent_change_30m'] = this.percentChange30m;
    data['percent_change_1h'] = this.percentChange1h;
    data['percent_change_6h'] = this.percentChange6h;
    data['percent_change_12h'] = this.percentChange12h;
    data['percent_change_24h'] = this.percentChange24h;
    data['percent_change_7d'] = this.percentChange7d;
    data['percent_change_30d'] = this.percentChange30d;
    data['percent_change_1y'] = this.percentChange1y;
    data['ath_price'] = this.athPrice;
    data['ath_date'] = this.athDate;
    data['percent_from_price_ath'] = this.percentFromPriceAth;
    return data;
  }
}