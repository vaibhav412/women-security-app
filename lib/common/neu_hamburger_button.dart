import 'package:flutter/material.dart';
import 'package:safe_women/screen/numbers/numbers.dart';

class NeuHamburgerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const NeuHamburgerButton({
    this.onPressed,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: NeumorphicContainer(
          color: Color.fromRGBO(227, 237, 247, 1),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange[900], width: 4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(227, 237, 247, 1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: Offset(-5, -5),
                      color: Colors.white,
                    ),
                    BoxShadow(
                      spreadRadius: -2,
                      blurRadius: 10,
                      offset: Offset(10.5, 10.5),
                      color: Color.fromRGBO(193, 214, 233, 1),
                    )
                  ],
                ),
                child: child,
              ),
            ),
          )),
    );
  }
}

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final EdgeInsets padding;

  NeumorphicContainer({
    Key key,
    this.child,
    this.bevel = 10.0,
    this.color,
    this.padding = const EdgeInsets.all(5.0),
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeumorphicContainerState createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: widget.padding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(-10,-10),
                    color: Color(0xffffffff),
                  ),
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(10, 10),
                    color: Color(0xffa1a1a1),
                  )
                ],
          gradient: LinearGradient(
            stops: [0,1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffe6e6e6), Color(0xffffffff)]
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
