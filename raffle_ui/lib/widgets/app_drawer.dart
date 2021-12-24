import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffle_ui/constants/home_colors.dart';
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
              padding: EdgeInsets.only(top: 32.0),
              color: HomeColors.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                        "KISS Gaming", 
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 24.0, color: Colors.white)
                        ),
                      ),
                    subtitle: Text(
                        "No Loss Games", 
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontSize: 14.0, color: Colors.white)
                        ),
                      ),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {  },
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.ticketAlt, color: HomeColors.pink),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                            child: Text("Raffle", style: GoogleFonts.roboto(textStyle: TextStyle(color: HomeColors.pink), fontSize: 18.0),),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: HomeColors.cardColor)
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
          if(widget.permanentlyDisplay)
            VerticalDivider(color: Colors.grey, width: 1)
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