import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart' as http;
import 'package:raffle_ui/constants/kiss/blockchain.dart';
import 'package:raffle_ui/models/coin_quote.dart';

class WalletProvider extends ChangeNotifier {
  static const operatingChain = 56;

  String currentAddress = '';

  int currentChain = -1;

  bool get isEthereumEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == operatingChain;

  bool get isConnected => currentAddress.isNotEmpty;

  int entrants = 0;
  int tickets = 0;
  bool kissEnabled = false;
  Contract? kissToken;
  Contract? raffleContract;
  WalletConnectProvider? binaceWc;
  Map<int, bool> ticketCanRedeem = {};

  BigInt yourBalance = BigInt.zero;

  int potPercent = 5;
  int potWinnerPercent = 0;
  int treasuryPercent = 0;
  int minTicketsForDraw = 0;
  int redeemDelay = 0;

  int kissBalance = 0;
  String tvl = "";
  String excess = "";
  String lovePrice = "";
  Iterable<int> ticketIds = [];

  Web3Provider? _provider;

  Future<void> connectToMetaMask() async {
    final accs = await ethereum!.requestAccount();
    if (accs.isNotEmpty) currentAddress = accs.first;
    currentChain = await ethereum!.getChainId();
    _provider = provider;
    await  update();
  }

  Future <void> connectWalletConnect() async {
    binaceWc = WalletConnectProvider.binance();
    await binaceWc!.connect();

    currentChain = binaceWc!.chainId as int;
    currentAddress = binaceWc!.accounts[0];

    _provider = Web3Provider.fromWalletConnect(binaceWc!);
    await update();
  }

  update() async {
    
    raffleContract = Contract(Blockchain.kissRaffleTokenAddress, Blockchain.raffleAbi, _provider!.getSigner());
      
    var circulatingSupply = await raffleContract!.call<BigNumber>("circulatingSupply");
    entrants = circulatingSupply.toInt;

    var balance = await raffleContract!.call<BigNumber>("balanceOf", [currentAddress]);
    tickets = balance.toInt;

    var winnerShare = await raffleContract!.call<BigNumber>("_winnerShare");
    potWinnerPercent = ((winnerShare.toInt) / 100) as int;

    var profitShare = await raffleContract!.call<BigNumber>("_profitShare");
    treasuryPercent = ((profitShare.toInt) / 100) as int;

    var delayInDays = await raffleContract!.call<BigNumber>("_delayInDays");
    redeemDelay = delayInDays.toInt;

    var minForRaffle = await raffleContract!.call<BigNumber>("minimumForRaffle");
    minTicketsForDraw = minForRaffle.toInt;

    var loveQuote = await fetchLovePrice();

    lovePrice = loveQuote.quotes.uSD.price.toStringAsFixed(2);

    var rExcess = await raffleContract!.call<BigNumber>("getExcess");
    excess = ((rExcess.toInt / Blockchain.oneKissToken) * loveQuote.quotes.uSD.price).toStringAsFixed(2);

    await isKissEnabled();

    var kBalance = await kissToken!.call<BigNumber>("balanceOf", [currentAddress]);
    kissBalance = kBalance.toInt;

    var rkBalance = await kissToken!.call<BigNumber>("balanceOf", [Blockchain.kissRaffleTokenAddress]);
    tvl = ((rkBalance.toInt / Blockchain.oneKissToken) * loveQuote.quotes.uSD.price).toStringAsFixed(2);

    var _ticketIds = await raffleContract!.call<List<dynamic>>("getOwnedTokenIds");
    
    //returns: {type: BigNumber, hex: 0x01}
    ticketIds = _ticketIds.map((e) => BigNumber.from(dartify(e)["hex"]).toInt);

    ticketIds.forEach((id) async {
      ticketCanRedeem[id] = await raffleContract!.call<bool>('canRedeem',[id]);
    });

    notifyListeners();
  }

  Future<CoinQuote> fetchLovePrice() async {
  final response = await http
      .get(Uri.parse('https://api.coinpaprika.com/v1/tickers/love-hunny-love-token'));

  if (response.statusCode == 200) {
    return CoinQuote.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}



  bool canRedeem(int tokenId){
    if(ticketCanRedeem.containsKey(tokenId)){
      return ticketCanRedeem[tokenId]!;
    }
    return false;
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  init() {
    ethereum?.onAccountsChanged((accounts) {
      clear();
    });
    ethereum?.onChainChanged((accounts) {
      clear();
    });

    binaceWc?.onAccountsChanged((accounts) {
      clear();
    });

    binaceWc?.onChainChanged((accounts) {
      clear();
    });
  }

  Future<void> enableKiss() async {
    var approvalFilter = kissToken!.getFilter('Approval', [null, Blockchain.kissRaffleTokenAddress]);
    kissToken!.on(approvalFilter, (owner, spender, value, event) async {
      await isKissEnabled();
      notifyListeners();
    });

    await kissToken!.call('approve', [Blockchain.kissRaffleTokenAddress, Blockchain.oneKissToken * 5]);
  }

  Future<void> isKissEnabled() async {
    kissToken = Contract(Blockchain.kissTokenAddress, Blockchain.kissAbi, _provider!.getSigner());
    var allowance = await kissToken!.call<BigNumber>("allowance", [currentAddress, Blockchain.kissRaffleTokenAddress]);
    kissEnabled = allowance.toInt >= Blockchain.oneKissToken;
  }

  Future<void> getATicket() async {
    var transferFilter = kissToken!.getFilter('Transfer', [currentAddress, Blockchain.kissRaffleTokenAddress]);
    kissToken!.on(transferFilter, (from, to, amount, event) async {
      await update();
    });

    await raffleContract!.call("mintTicket");
  }

  Future<void> redeemKiss(int tokenId) async {
    var transferFilter = kissToken!.getFilter('Transfer', [null, currentAddress]);
    kissToken!.on(transferFilter, (from, to, amount, event) async {
      await update();
    });

    await raffleContract!.call("redeemKiss", [tokenId]);
  }

}
