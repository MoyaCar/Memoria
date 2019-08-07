import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memoria/FlipeableCard.dart';
import 'dart:math';

import 'matcher_bloc.dart';

Matcheador matcheador = Matcheador();

bool primerTarjeta = false;
bool segundaTarjeta = false;
bool match = false;
int valorPrimeraTarjeta = 0;
int valorSegundaTarjeta = 0;
int valorTotal = valorPrimeraTarjeta + valorSegundaTarjeta;

void main() => runApp(MyApp());

Color cartaColor = Color(0xff98bb6e);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemoriaHome(),
    );
  }
}

class MemoriaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MemoriaHomeState();
  }
}

class MemoriaHomeState extends State<MemoriaHome>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [
              0,
              0.7,
              1,
            ],
            colors: [
              Color(0xff3b2574),
              Color(0xff483588),
              Color(0xff7870aa),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridDeFich(),
      ),
    );
  }
}

class GridDeFich extends StatefulWidget {
  GridDeFich({Key key}) : super(key: key);

  _GridDeFichState createState() => _GridDeFichState();
}

class _GridDeFichState extends State<GridDeFich> {
  int sumaDeId;
  bool primeraActivada;
  bool segundaActivada;
  //
  //
  var randomNumber = Random();
  List<Widget> iconos = [
    Icon(Icons.ac_unit),
    Icon(Icons.access_alarm),
    Icon(Icons.accessibility),
    Icon(Icons.ac_unit),
    Icon(Icons.access_alarm),
    Icon(Icons.accessibility)
  ];

//
  Widget asignarIconoAlAzar() {
    Icon _iconoAsignado;
    int numeroAlAzar = randomNumber.nextInt(iconos.length);
    _iconoAsignado = iconos[numeroAlAzar];
    iconos.removeAt(numeroAlAzar);
    return _iconoAsignado;
  }

//
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: matcheador.stream$,
      builder: (BuildContext context, snap) {
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            iconos.length,
            (index) {
              return Carta2(
                icono: asignarIconoAlAzar(),
              );
            },
          ),
        );
      },
    );
  }
}
//Clase Para Grid de Fichas.
//

//Clase de Carta.
class Carta extends StatefulWidget {
  final Icon icono;

  const Carta({Key key, this.icono}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CartaState(icono);
  }
}

class CartaState extends State<Carta> with SingleTickerProviderStateMixin {
  AnimationController _controlDeGiroDeCarta;
  Animation<double> _animacionDeGiroDeCarta;
  double comienzoDeAnimacion = 3.14 / 1;
  double finDeAnimacion = 3.14 / 20;
  bool matcher = false;
  int valor = 1;
  final Icon icono;

  CartaState(this.icono);

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
    return StreamBuilder(
      stream: matcheador.cartaUno$,
      builder: (context, cartauno) {
        return StreamBuilder(
          stream: matcheador.cartaDos$,
          builder: (context, cartados) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (cartauno.data == false) {
                    valorPrimeraTarjeta = valor;
                    matcheador.primerCarta();
                    _controlDeGiroDeCarta.forward();
                  } else {
                    valorSegundaTarjeta = valor;
                    matcheador.segundaCarta();
                    _controlDeGiroDeCarta.forward();
                    print(segundaTarjeta);
                  }
                },
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0006)
                    ..rotateX(_animacionDeGiroDeCarta.value),
                  alignment: Alignment.center,
                  child: Card(
                    color: _animacionDeGiroDeCarta.value > (3.14 / 2)
                        ? cartaColor
                        : Colors.black38,
                    child: Center(
                      child: icono,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
