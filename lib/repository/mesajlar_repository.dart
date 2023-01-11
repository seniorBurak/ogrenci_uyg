import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MesajlarRepository extends ChangeNotifier {
  List<Mesaj> mesajlar = [
    Mesaj(
        "Merhaba", "Ali", DateTime.now().subtract(const Duration(minutes: 3))),
    Mesaj("Orda mısın?", "Ali",
        DateTime.now().subtract(const Duration(minutes: 3))),
    Mesaj("evet", "Ayşe", DateTime.now().subtract(const Duration(minutes: 3))),
    Mesaj("Nasılsın", "Ayşe",
        DateTime.now().subtract(const Duration(minutes: 3))),
  ];
}

final mesajlarProvider = ChangeNotifierProvider((ref) {
  return MesajlarRepository();
});

class YeniMesajSayisi extends StateNotifier<int> {
  YeniMesajSayisi(super.state);

  void sifirla() {
    state = 0;
  }
}

final yeniMesajSayisiProvider =
    StateNotifierProvider<YeniMesajSayisi, int>((ref) {
  return YeniMesajSayisi(4);
});

class Mesaj {
  String yazi;
  String gonderen;
  DateTime zaman;

  Mesaj(this.yazi, this.gonderen, this.zaman);
}
