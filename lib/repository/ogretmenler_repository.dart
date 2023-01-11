import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OgretmenlerRepository extends ChangeNotifier {
  List ogretmenler = [
    Ogretmen("burak", "demirel", 27, "erkek"),
    Ogretmen("yavuz ", "behlül", 27, "erkek"),
  ];
}

final ogretmenlerProvider = ChangeNotifierProvider((ref) {
  return OgretmenlerRepository();
});

class Ogretmen {
  String ad;
  String soyad;
  int yas;
  String cinsiyet;

  Ogretmen(this.ad, this.soyad, this.yas, this.cinsiyet);
}
