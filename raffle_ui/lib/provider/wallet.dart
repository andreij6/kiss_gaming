import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:raffle_ui/constants/blockchain.dart';

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

  int kissBalance = 0;
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

    await isKissEnabled();

    var kBalance = await kissToken!.call<BigNumber>("balanceOf", [currentAddress]);
    kissBalance = kBalance.toInt;

    var _ticketIds = await raffleContract!.call<List<dynamic>>("getOwnedTokenIds");
    
    //returns: {type: BigNumber, hex: 0x01}
    ticketIds = _ticketIds.map((e) => BigNumber.from(dartify(e)["hex"]).toInt);

    ticketIds.forEach((id) async {
      ticketCanRedeem[id] = await raffleContract!.call<bool>('canRedeem',[id]);
    });

    notifyListeners();
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