import 'package:flutter/material.dart';
import 'package:raffle_ui/widgets/ticket_clipper.dart';

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
        duration: const Duration(seconds: 3),
        width: widget.width,
        height: widget.height,
        child: widget.child,
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15.0))
        ),
      ),
    );
  }
}
