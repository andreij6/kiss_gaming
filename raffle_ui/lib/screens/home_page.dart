import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:raffle_ui/constants/blockchain.dart';
import 'package:raffle_ui/constants/home_colors.dart';
import 'package:raffle_ui/provider/wallet.dart';
import 'package:raffle_ui/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var titleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontSize: 32.0));
  var ticketTitleTextStyle = GoogleFonts.lato(textStyle: TextStyle(color: HomeColors.cardColor, fontWeight: FontWeight.bold, fontSize: 24.0));
  var statsTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: HomeColors.moneyGreen, fontSize: 24.0));
  var contentTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontSize: 18.0));
  var infoTextStyle = GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 16.0));
  var linkTextStyle = GoogleFonts.lato(textStyle: TextStyle(color: Colors.blue, fontSize: 14.0, decoration: TextDecoration.underline));

  var walletTitleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold));
  var walletSubtitleTextStyle = GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey, fontSize: 14.0));
  var walletButtonStyle = ElevatedButton.styleFrom(primary: Colors.white);

  var darkContentTextStyle = GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0));
  var buttonTextStyle = GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold));
  var buttonStyle = ElevatedButton.styleFrom(primary: HomeColors.pink);
  var disabledButtonStyle = ElevatedButton.styleFrom(primary: HomeColors.secondaryButtonColor);
  var linkButtonStyle = ElevatedButton.styleFrom(primary: HomeColors.secondaryButtonColor);

  @override
  Widget build(BuildContext context) {

    final bool displayMobileLayout = MediaQuery.of(context).size.width < 1000;
    final bool displayCollapsedLayout = MediaQuery.of(context).size.width > 650 && MediaQuery.of(context).size.width < 1000;
    
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
                decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: const [0.0, 0.1, 0.2, 0.3],
                    colors: [
                      HomeColors.backgroundColor, 
                      HomeColors.backgroundColor, 
                      HomeColors.backgroundBreakOne,
                      HomeColors.backgroundColor
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
                Card(
                  color: HomeColors.cardColor,
                  child: Container(
                    width: 475.0,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("\$KISS No-Loss Raffle", style: titleTextStyle.copyWith(color: HomeColors.pink)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text("\n\nTrade 1 \$KISS for a Raffle Ticket and a chance to win a bigger prize than you would through APY alone. \n\nPrize's are awarded in \$KISS tokens & will be distributed directly to the winners wallet.", style: contentTextStyle, textAlign: TextAlign.center),
                              ),
                              ..._middleInfoCardComponent(provider),
                              Text("Important Information", style: infoTextStyle.copyWith(fontWeight: FontWeight.bold, color: HomeColors.infoTextColor)),
                              Text("\u2022 Raffles occur when TVL earns enough interest to fund a new drawing.", style: infoTextStyle),
                              Text("\u2022 After a 5 day lock period, you can trade-in a raffle ticket for 1 \$KISS.", style: infoTextStyle),
                              Text("\u2022 Winners must have \$KISS token balance in the wallet that owns the ticket at the time of the drawing to be awarded prize.", style: infoTextStyle)
                            ],
                          )
                  ),
                ),
                const SizedBox(height: 12.0),
                ..._listTickets(provider)
              ],
            );
          }
        )
      ),
    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  List<Widget> _middleInfoCardComponent(WalletProvider provider){
    if(provider.isConnected && provider.isInOperatingChain){
      return [
        Divider(color: HomeColors.pink),
        Text(provider.entrants.toString() + " Tickets in Raffle", style: statsTextStyle),
        Text("You own " + provider.tickets.toString() + " Tickets", style: statsTextStyle),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._participationButtons(provider)
            ]
          ),
        ),
        Divider(color: HomeColors.pink),
      ];
    } else {
      return [
        Divider(color: HomeColors.pink),
        Text("Connect a wallet to get started", style: statsTextStyle, textAlign: TextAlign.center),
        Divider(color: HomeColors.pink),
      ];
    }
    
  }

  List<Widget> _participationButtons(WalletProvider provider){

    if(provider.kissBalance < Blockchain.oneKissToken){
      return [
        Spacer(),
        ElevatedButton(onPressed: (){
          launch("https://dao.hunny.finance/");
        }, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Text("Stake \$LOVE get \$KISS tokens", style: buttonTextStyle),
        ), style: linkButtonStyle),
        Spacer(),
      ];
    } else if(provider.kissEnabled == false) {
      return [
        ElevatedButton(onPressed: (){
          provider.enableKiss();
        }, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Text("Enable \$KISS", style: buttonTextStyle),
          ), style: buttonStyle),
        const SizedBox(width: 4.0),
        ElevatedButton(onPressed: (){}, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Text("Get a Raffle Ticket", style: buttonTextStyle),
        ), style: provider.kissEnabled ? buttonStyle : disabledButtonStyle)
      ];
    }  else {
      return [
        Spacer(),
        ElevatedButton(onPressed: (){
          provider.getATicket();
        }, child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Text("Get a Raffle Ticket", style: buttonTextStyle),
        ), style: provider.kissEnabled ? buttonStyle : disabledButtonStyle),
        Spacer(),
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
    return FlutterTicketWidget(
          width: 425.0,
          height: 300.0,
          color: Colors.white,
          isCornerRounded: true,
          child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
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
                              border: Border.all(width: 1.0, color: HomeColors.textOnWhite),
                            ),
                            child: Center(
                              child: Text(
                                'Kiss Raffle Token',
                                style: TextStyle(color: HomeColors.textOnWhite),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '1 KRT',
                                style: contentTextStyle.copyWith(color: HomeColors.textOnWhite),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.sync_alt_sharp,
                                  color: HomeColors.textOnWhite,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '1 KISS',
                                  style: contentTextStyle.copyWith(color: HomeColors.textOnWhite),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                            'Ticket ID:' + tokenId.toString(),
                            style: ticketTitleTextStyle
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 60.0),
                        child: Container(
                          width: 250.0,
                          height: 60.0,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Text(provider.canRedeem(tokenId) || !isActive ? "Hold for Next Raffle OR" : "Kiss Locked for 5-days", style: infoTextStyle.copyWith(color: HomeColors.textOnWhite)),
                            const SizedBox(width: 24.0),
                            ElevatedButton(onPressed: () async {
                              if(isActive && provider.canRedeem(tokenId)) {
                                await provider.redeemKiss(tokenId);
                              }
                            }, child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text("Redeem \$KISS", style: buttonTextStyle),
                            ), style: provider.canRedeem(tokenId) || !isActive ? buttonStyle : disabledButtonStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
        );
  }

  Widget _walletButton(){
    return Consumer<WalletProvider>(
      builder: (context, provider, child) {
        if(provider.isConnected && provider.isInOperatingChain){
          var address = provider.currentAddress.substring(0,4) + "...." + provider.currentAddress.substring(provider.currentAddress.length - 5);
          return ElevatedButton(onPressed: (){ }, child: Text(address, style: buttonTextStyle), style: ElevatedButton.styleFrom(primary: HomeColors.secondaryButtonColor));
        } else if(provider.isConnected && !provider.isInOperatingChain){
          return ElevatedButton(onPressed: (){}, child: Text('Wrong chain. Please connect to BSC', style: buttonTextStyle), style: buttonStyle);
        } else if(provider.isEthereumEnabled == false){
          return ElevatedButton(onPressed: (){
            provider.connectWalletConnect();
          }, child: Text("Connect Wallet", style: buttonTextStyle), style: buttonStyle);
        } else if(provider.isEthereumEnabled){
          return ElevatedButton(onPressed: (){
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
                        Divider(color: Colors.black12),
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
          }, child: Text("Connect Wallet", style: buttonTextStyle), style: buttonStyle);
        } else {
          return ElevatedButton(onPressed: (){}, child: Text("Use a Web3 Browser", style: buttonTextStyle), style: ElevatedButton.styleFrom(primary: Colors.grey));
        } 
      }
    );
  }
}

class FlutterTicketWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;

  FlutterTicketWidget(
      { 
        required this.width,
        required this.height,
        required this.child,
        this.color = Colors.white,
        this.isCornerRounded = false
      }
  );

  @override
  _FlutterTicketWidgetState createState() => _FlutterTicketWidgetState();
}

class _FlutterTicketWidgetState extends State<FlutterTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: Duration(seconds: 3),
        width: widget.width,
        height: widget.height,
        child: widget.child,
        decoration: BoxDecoration(
            color: widget.color),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(
        center: Offset(0.0, 0.0), radius: 30.0));

    path.addOval(Rect.fromCircle(
        center: Offset(size.width, 0.0), radius: 30.0));    

    path.addOval(Rect.fromCircle(
        center: Offset(0.0, size.height), radius: 30.0)); //bottom left

    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height), radius: 30.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DashedLine({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}