
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

class Carta2 extends StatefulWidget {
  final Icon icono;

  const Carta2({Key key, this.icono}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Carta2State(icono);
  }
}

class Carta2State extends State<Carta2> with SingleTickerProviderStateMixin {
  AnimationController _controlDeGiroDeCarta;
  Animation<double> _animacionDeGiroDeCarta;
  double comienzoDeAnimacion = 3.14 / 1;
  double finDeAnimacion = 3.14 / 20;
  final Icon icono;

  Carta2State(this.icono);

  @override
  void initState() {
    super.initState();
    _controlDeGiroDeCarta = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animacionDeGiroDeCarta =
        Tween<double>(begin: comienzoDeAnimacion, end: finDeAnimacion)
            .animate(_controlDeGiroDeCarta)
              ..addListener(() {
                setState(() {});
              });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animacionDeGiroDeCarta.isCompleted
            ? _controlDeGiroDeCarta.reverse()
            : _controlDeGiroDeCarta.forward();
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0006)
          ..rotateX(_animacionDeGiroDeCarta.value),
        alignment: Alignment.center,
        child: Card(
          color: _animacionDeGiroDeCarta.value > (3.14 / 2)
              ? Colors.white24
              : Colors.black38,
          child: Center(
            child: icono,
          ),
        ),
      ),
    );
  }
}
