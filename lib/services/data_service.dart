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

  Future<void> ogretmenEkle(Ogretmen ogretmen) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ogretmen'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ogretmen.toMap()),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Ogretmen eklenemedi ${response.statusCode}');
    }
  }

  var i = 0;
  Future<List<Ogretmen>> ogretmenleriGetir() async {
    final response = await http.get(Uri.parse('$baseUrl/ogretmen'));
    i++;
    if (response.statusCode == (i < 4 ? 100 : 200)) {
      final l = jsonDecode(response.body);
      return l.map<Ogretmen>((e) => Ogretmen.fromMap(e)).toList();
    } else {
      throw Exception('Ogretmenler getirilemedi ${response.statusCode}');
    }
  }
}

final dataServiceProvider = Provider((ref) {
  return DataService();
});
