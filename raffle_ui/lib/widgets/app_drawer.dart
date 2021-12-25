import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffle_ui/constants/kiss/kiss_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {

  AppDrawer({this.permanentlyDisplay = false, Key? key})
      : super(key: key);

  bool permanentlyDisplay;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  //static String? _selectedRoute = RouteNames.home;
  //late RouteObserver<ModalRoute<void>> _routeObserver;
  @override
  void initState() {
    super.initState();
    //_routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    //_routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 32.0),
              color: KissColors.cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                        "No Loss Gaming", 
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 24.0, color: Colors.white)
                        ),
                      ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Icon(FontAwesomeIcons.ticketAlt, color: KissColors.pink),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text("Raffle", style: GoogleFonts.quicksand(textStyle: TextStyle(color: KissColors.pink, fontWeight: FontWeight.bold), fontSize: 18.0),),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {}
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {  },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text("KISS", style: GoogleFonts.quicksand(textStyle: TextStyle(color: KissColors.pink, fontWeight: FontWeight.bold), fontSize: 18.0),),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.grey[700], 
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      )
                    ),
                    onTap: () async {}
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: (){
                            launch("https://twitter.com/HunnyFinance");
                          },
                          icon: const Icon(FontAwesomeIcons.twitter, color: Colors.white)
                        ),
                        IconButton(
                          onPressed: (){
                            launch("https://discord.gg/d4fxKZFxPv");
                          },
                          icon: const Icon(FontAwesomeIcons.discord, color: Colors.white)
                        ),
                      ]
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Closes the drawer if applicable (which is only when it's not been displayed permanently) and navigates to the specified route
  /// In a mobile layout, the a modal drawer is used so we need to explicitly close it when the user selects a page to display
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushNamed(context, routeName);
  }

  void _updateSelectedRoute() {
    setState(() {
      //_selectedRoute = ModalRoute.of(context)?.settings.name;
    });
  }
}