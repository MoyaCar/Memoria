import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  List<int> valores = [
    1,
    2,
    3,
    1,
    2,
    3,
  ];

  int position;

//
  Widget asignarIconoAlAzar() {
    Icon _iconoAsignado;
    int numeroAlAzar = randomNumber.nextInt(iconos.length);
    _iconoAsignado = iconos[numeroAlAzar];
    iconos.removeAt(numeroAlAzar);
    position = numeroAlAzar;
    return _iconoAsignado;
  }

  int asignarValor() {
    int valor = valores[position];
    valores.removeAt(position);
    return valor;
  }

//
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(
        iconos.length,
        (index) {
          return Carta(
            icono: asignarIconoAlAzar(),
            valor: asignarValor(),
          );
        },
      ),
    );
  }
}
//Clase Para Grid de Fichas.
//

//Clase de Carta.
class Carta extends StatefulWidget {
  final Icon icono;
  final int valor;

  const Carta({Key key, this.icono, this.valor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartaState(icono, valor);
  }
}

class CartaState extends State<Carta> with SingleTickerProviderStateMixin {
  AnimationController _controlDeGiroDeCarta;
  Animation<double> _animacionDeGiroDeCarta;
  double comienzoDeAnimacion = 3.14 / 1;
  double finDeAnimacion = 3.14 / 20;
  bool haMatcheado = false;
  bool tocada = false;
  int valor;
  final Icon icono;

  CartaState(this.icono, this.valor);

  @override
  void initState() {
    super.initState();
    _controlDeGiroDeCarta =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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
      stream: matcheador.stream$,
      builder: (context, matcher) {
        return StreamBuilder(
          stream: matcheador.cartaUno$,
          builder: (context, cartauno) {
            return StreamBuilder(
              stream: matcheador.cartaDos$,
              builder: (context, cartados) {
                if (matcher.data == true && tocada == true) {
                  haMatcheado = true;
                  matcheador.notMatch();
                  tocada = false;
                }
                if (cartauno.data && cartados.data && !haMatcheado) {
                  revertirCarta();
                  tocada = false;
                }
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      if (cartauno.data == false) {
                        valorPrimeraTarjeta = valor;
                        tocada = true;
                        matcheador.primerCarta();
                        _controlDeGiroDeCarta.forward();
                        print(valor);
                      }
                      if (cartauno.data == true) {
                        valorSegundaTarjeta = valor;

                        girarSegundaCarta();

                        print('segunda carta');
                        print(valor);
                        if (valorPrimeraTarjeta == valorSegundaTarjeta) {
                          haMatcheado = true;
                          matcheador.cardMatcher();
                        }
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
      },
    );
  }

  void girarSegundaCarta() async {
    _controlDeGiroDeCarta.forward();
    await Future.delayed(Duration(milliseconds: 300));
    matcheador.segundaCarta();
  }

  void revertirCarta() async {
    _controlDeGiroDeCarta.reverse();
    await Future.delayed(Duration(milliseconds: 300));
    matcheador.notMatch();
  }
}
