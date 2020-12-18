import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NeuStartButton extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;
  final VoidCallback onPressed;

  NeuStartButton({
    Key key,
    this.bevel = 10.0,
    this.onPressed,
  })
      : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeuStartButtonState createState() => _NeuStartButtonState();
}

class _NeuStartButtonState extends State<NeuStartButton> {
  bool _isPressed = false;

  void _onPointerDown() {
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
      onPointerDown: (_) {
        _onPointerDown();
      },
      onPointerUp: _onPointerUp,
      child: FlatButton(
        onPressed: widget.onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 95,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow:  [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(1,1),
                color: _isPressed ? Colors.greenAccent : Colors.redAccent,
              ),
              BoxShadow(
                blurRadius: 5,
                offset: Offset(-1, -1),
                color: _isPressed ? Colors.greenAccent : Colors.redAccent,
              )
            ],
            gradient: LinearGradient(
              stops: [0,1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isPressed ? [Color(0xffdedede) , Color(0xffffffff)] : [Color(0xffffffff), Color(0xffdedede)]
            ),
          ),
          child: Center(
            child: SvgPicture.asset('icons/sos.svg'),
          ),
        ),
      ),
    );
  }
}


