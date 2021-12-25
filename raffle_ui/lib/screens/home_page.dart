import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raffle_ui/constants/kiss/blockchain.dart';
import 'package:raffle_ui/constants/kiss/kiss_colors.dart';
import 'package:raffle_ui/provider/wallet.dart';
import 'package:raffle_ui/widgets/app_card.dart';
import 'package:raffle_ui/widgets/app_drawer.dart';
import 'package:raffle_ui/widgets/configuration_row_item.dart';
import 'package:raffle_ui/widgets/flutter_ticket_widget.dart';
import 'package:raffle_ui/widgets/raffle_state_item.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var titleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontSize: 32.0));
  var ticketTitleTextStyle = GoogleFonts.quicksand(textStyle: TextStyle(color: KissColors.cardColor, fontWeight: FontWeight.bold, fontSize: 24.0));
  var statsTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: KissColors.moneyGreen, fontSize: 24.0));
  var contentTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontSize: 18.0));
  var infoTextStyle = GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontSize: 16.0));
  var infoTitleTextStyle = GoogleFonts.openSans(textStyle: TextStyle(color: KissColors.infoTextColor, fontSize: 16.0, letterSpacing: 2.0));
  var linkTextStyle = GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue, fontSize: 14.0, decoration: TextDecoration.underline));

  var walletTitleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold));
  var walletSubtitleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey, fontSize: 14.0));
  var walletButtonStyle = ElevatedButton.styleFrom(primary: Colors.white);

  var darkContentTextStyle = GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0));
  var buttonTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontSize: 16.0));
  var buttonStyle = ElevatedButton.styleFrom(primary: KissColors.pink);
  var disabledButtonStyle = ElevatedButton.styleFrom(primary: KissColors.secondaryButtonColor);
  var linkButtonStyle = ElevatedButton.styleFrom(primary: KissColors.secondaryButtonColor);

  @override
  Widget build(BuildContext context) {

    final bool displayMobileLayout = MediaQuery.of(context).size.width < 1000;
    
    return ChangeNotifierProvider(
      create: (_) => WalletProvider()..init(),
      builder: (context, child) {
        return Row(
          children: [
            if(!displayMobileLayout)
              AppDrawer(
                permanentlyDisplay: true,
              ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.0, 0.1, 0.4],
                    colors: [
                      KissColors.backgroundColor, 
                      KissColors.backgroundBreakOne,
                      KissColors.backgroundColor
                      ]
                    )
                  ),
                child: Scaffold(
                  drawer: displayMobileLayout
                    ? AppDrawer(
                        permanentlyDisplay: false,
                      )
                    : null,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _walletButton(),
                      )
                    ],
                  ),
                  body: _body(), // This trailing comma makes auto-formatting nicer for build methods.
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Consumer<WalletProvider>(
            builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 12.0),
                AppCard(
                  cardBody: Container(
                    width: 475.0,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._gameInfoCardComponent(provider)
                            ],
                          )
                  ),
                ),
                const SizedBox(height: 12.0),
                if(provider.isConnected && provider.isInOperatingChain)
                  AppCard(
                    cardBody: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._userInfoCardComponent(provider),
                      ],
                    ),
                  ),
                const SizedBox(height: 12.0),
                if(provider.isConnected && provider.isInOperatingChain)
                  AppCard(
                    cardBody: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._configurationsInfoCardComponent(provider),
                      ],
                    )
                  ),
                if(provider.isConnected && provider.isInOperatingChain)  
                  const SizedBox(height: 12.0),
                AppCard(
                  cardBody: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("About the Raffle", style: infoTitleTextStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("\u2022 Trade 1 \$KISS for a Raffle Ticket ", style: infoTextStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("\u2022 Prize's are awarded in \$KISS tokens & will be distributed directly to the winners wallet.", style: infoTextStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("\u2022 Raffles occur when TVL earns enough interest to fund a new drawing.", style: infoTextStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("\u2022 After a 5 day lock period, you can trade-in a raffle ticket for 1 \$KISS.", style: infoTextStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("\u2022 Winners must have \$KISS token balance in the wallet that owns the ticket at the time of the drawing to be awarded prize.", style: infoTextStyle),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 12.0),
                ..._listTickets(provider),
                const SizedBox(height: 12.0),
              ],
            );
          }
        )
      ),
    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child: const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  List<Widget> _gameInfoCardComponent(WalletProvider provider){
    if(provider.isConnected && provider.isInOperatingChain){
      return [
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaffleStateItem(
              category: "\$LOVE",
              value: provider.lovePrice.toString()
            ),
            RaffleStateItem(
              category: "TVL",
              value: provider.tvl.toString()
            ),
            RaffleStateItem(
              category: "POT",
              value: provider.excess.toString()
            ),
            RaffleStateItem(
              category: "Entries",
              value: provider.entrants.toString(),
              isMoney: false
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                launch("https://coinpaprika.com/coin/love-hunny-love-token/");
              },
              child: Text("Prices powered by CoinPaprika API", style: linkTextStyle)
            ),
          ],
        ),
      ];
    } else {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text("Connect Wallet", style: statsTextStyle.copyWith(color: KissColors.pink), textAlign: TextAlign.center),
            ),
          ],
        ),
      ];
    }
  }

  List<Widget> _configurationsInfoCardComponent(WalletProvider provider){
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Configurations", style: infoTitleTextStyle),
      ),
      ConfigurationRowItem(
        category: "% of TVL allocated to POT:", 
        value: provider.potPercent.toString() + "%",
        textStyle: infoTextStyle
      ),
      ConfigurationRowItem(
        category: "% of POT to the Winner:", 
        value: provider.potWinnerPercent.toString() + "%",
        textStyle: infoTextStyle
      ),
      ConfigurationRowItem(
        category: "% of POT to the Treasury:", 
        value: provider.treasuryPercent.toString() + "%",
        textStyle: infoTextStyle
      ),
      ConfigurationRowItem(
        category: "Minimum Tickets for Drawing:", 
        value: provider.minTicketsForDraw.toString(),
        textStyle: infoTextStyle
      ),
      ConfigurationRowItem(
        category: "\$KISS deposit redeem hold:", 
        value: provider.redeemDelay.toString() + " days",
        textStyle: infoTextStyle
      )
    ];
  }

  List<Widget> _userInfoCardComponent(WalletProvider provider) {
    return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You own " + provider.tickets.toString() + " Ticket" + ((provider.tickets > 1) ? "s" :""), style: statsTextStyle),
          ],
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._participationButtons(provider)
              ]
            ),
          )
      ];
  }

  List<Widget> _participationButtons(WalletProvider provider){

    if(provider.kissBalance < Blockchain.oneKissToken){
      return [
        const Spacer(),
        ElevatedButton(onPressed: (){
          launch("https://dao.hunny.finance/");
        }, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Text("Stake \$LOVE get \$KISS tokens", style: buttonTextStyle),
        ), style: linkButtonStyle),
        const Spacer(),
      ];
    } else if(provider.kissEnabled == false) {
      return [
        ElevatedButton(onPressed: (){
          provider.enableKiss();
        }, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Text("Enable \$KISS", style: buttonTextStyle),
          ), style: buttonStyle),
        const SizedBox(width: 4.0),
        ElevatedButton(onPressed: (){}, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Text("Get a Raffle Ticket", style: buttonTextStyle),
        ), style: provider.kissEnabled ? buttonStyle : disabledButtonStyle)
      ];
    }  else {
      return [
        const Spacer(),
        ElevatedButton(onPressed: (){
          provider.getATicket();
        }, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Text("Get a Raffle Ticket", style: buttonTextStyle),
        ), style: provider.kissEnabled ? buttonStyle : disabledButtonStyle),
        const Spacer(),
      ];
    }
    
  }

  List<Widget> _listTickets(WalletProvider provider) {
    if(provider.isConnected && provider.isInOperatingChain){
      List<Widget> tickets = [];

      provider.ticketIds.forEach((id) {
        tickets.add(_flutterTicket(provider, id, true));
      });

      return tickets;
    } else {
      return [
        _flutterTicket(provider, 777, false)
      ];
    }
  }

  Widget _flutterTicket(WalletProvider provider, int tokenId, bool isActive){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FlutterTicketWidget(
            width: 425.0,
            height: 300.0,
            color: Colors.white,
            isCornerRounded: true,
            child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(width: 1.0, color: KissColors.textOnWhite),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Kiss Raffle Token',
                                    style: TextStyle(color: KissColors.textOnWhite),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '1 KRT',
                                    style: contentTextStyle.copyWith(color: KissColors.textOnWhite),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.sync_alt_sharp,
                                      color: KissColors.textOnWhite,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '1 KISS',
                                      style: contentTextStyle.copyWith(color: KissColors.textOnWhite),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                                'Ticket ID:' + tokenId.toString(),
                                style: ticketTitleTextStyle
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 60.0),
                            child: Container(
                              width: 250.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/barcode.png'),
                                      fit: BoxFit.cover)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: (){
                                launch("https://bscscan.com/address/" + Blockchain.kissRaffleTokenAddress);
                              },
                              child: Text(
                                Blockchain.kissRaffleTokenAddress,
                                style: linkTextStyle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed: () async {
                                    if(isActive && provider.canRedeem(tokenId)) {
                                      await provider.redeemKiss(tokenId);
                                    }
                                  }, child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: Text("Redeem \$KISS", style: buttonTextStyle),
                                  ), style: provider.canRedeem(tokenId) || !isActive ? buttonStyle : disabledButtonStyle
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
          ),
    );
  }

  Widget _walletButton(){
    return Consumer<WalletProvider>(
      builder: (context, provider, child) {
        if(provider.isConnected && provider.isInOperatingChain){
          var address = provider.currentAddress.substring(0,4) + "...." + provider.currentAddress.substring(provider.currentAddress.length - 5);
          return Container(
            height: 44.0,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [KissColors.pink, Colors.purple]), borderRadius: BorderRadius.circular(8.0)),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
              child: Text(address, style: buttonTextStyle),
            ),
          );
        } else if(provider.isConnected && !provider.isInOperatingChain){
          return ElevatedButton(onPressed: (){}, child: Text('Wrong chain. Please connect to BSC', style: buttonTextStyle), style: buttonStyle);
        } else if(provider.isEthereumEnabled == false){
          return Container(
            height: 44.0,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [KissColors.pink, Colors.purple]), borderRadius: BorderRadius.circular(8.0)),
            child: ElevatedButton(
              onPressed: () {
                provider.connectWalletConnect();
              },
              style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
              child: Text("Connect Wallet", style: buttonTextStyle),
            ),
          );
        } else if(provider.isEthereumEnabled){
          return Container(
            height: 44.0,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [KissColors.pink, Colors.purple]), borderRadius: BorderRadius.circular(8.0)),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context){
                    return Dialog(
                      backgroundColor: Colors.white,
                      child: SizedBox(
                        width: 425,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                provider.connectToMetaMask();
                                Navigator.pop(context);
                              }, 
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/metamask.svg',
                                      semanticsLabel: 'Metamask Logo',
                                      height: 48.0
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text("MetaMask", style: walletTitleTextStyle, textAlign: TextAlign.center),
                                    ),
                                    Text("Connect to your Metamask Wallet", style: walletSubtitleTextStyle, textAlign: TextAlign.center)
                                  ]
                                ),
                              ),
                              style: walletButtonStyle
                            ),
                            const Divider(color: Colors.black12),
                            TextButton(
                              onPressed: () async {
                                provider.connectWalletConnect();
                                Navigator.pop(context);
                              }, 
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/wallet_connect.svg',
                                      semanticsLabel: 'Wallet Connect Logo',
                                      height: 48.0
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text("WalletConnect", style: walletTitleTextStyle, textAlign: TextAlign.center),
                                    ),
                                    Text("Scan with WalletConnect to connect", style: walletSubtitleTextStyle, textAlign: TextAlign.center)
                                  ]
                                ),
                              ),
                              style: walletButtonStyle
                            )
                          ]
                        )
                      )
                    );
                  }
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
              child: Text("Connect Wallet", style: buttonTextStyle),
            ),
          );
        } else {
          return ElevatedButton(onPressed: (){}, child: Text("Use a Web3 Browser", style: buttonTextStyle), style: ElevatedButton.styleFrom(primary: Colors.grey));
        } 
      }
    );
  }
}

