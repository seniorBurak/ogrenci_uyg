import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ogrenci_uyg/models/ogretmen.dart';

class DataService {
  final String baseUrl = 'https://63c28d8de3abfa59bdaed3af.mockapi.io';

  Future<Ogretmen> ogretmenIndir() async {
    final response = await http.get(Uri.parse('$baseUrl/ogretmen/1'));

    if (response.statusCode == 200) {
      return Ogretmen.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Ogretmen indirilemedi ${response.statusCode}');
    }
  }
}

final dataServiceProvider = Provider((ref) {
  return DataService();
});
