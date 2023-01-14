import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogrenci_uyg/services/data_service.dart';

import '../models/ogretmen.dart';

class OgretmenlerRepository extends ChangeNotifier {
  List ogretmenler = [
    Ogretmen("burak", "demirel", 27, "erkek"),
    Ogretmen("yavuz ", "behlül", 27, "erkek"),
  ];
  final DataService dataService;
  OgretmenlerRepository(this.dataService);

  Future<void> indir() async {
    Ogretmen ogretmen = await dataService.ogretmenIndir();

    ogretmenler.add(ogretmen);
    notifyListeners(); // ekran yenilenmesi için
  }
}

final ogretmenlerProvider = ChangeNotifierProvider((ref) {
  return OgretmenlerRepository(ref.watch(dataServiceProvider));
});
