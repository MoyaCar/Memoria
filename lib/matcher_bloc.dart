import 'package:rxdart/rxdart.dart';

class Matcheador {
  BehaviorSubject _primeraCarta = BehaviorSubject.seeded(false);
  BehaviorSubject _segundaCarta = BehaviorSubject.seeded(false);
  BehaviorSubject _matcher = BehaviorSubject.seeded(false);
  Observable get stream$ => _matcher.stream;
  Observable get cartaUno$ => _primeraCarta.stream;
  Observable get cartaDos$ => _segundaCarta.stream;
  bool get status=> _matcher.value;

  primerCarta() {
    _primeraCarta.add(true);
  }

  segundaCarta() {
    _segundaCarta.add(true);
  }

  cardMatcher() {
    _matcher.add(true);
  }

  notMatch() {
    _primeraCarta.add(false);
    _segundaCarta.add(false);
    _matcher.add(false);
  }
}
