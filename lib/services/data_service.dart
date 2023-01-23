import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    await FirebaseFirestore.instance
        .collection('ogretmenler')
        .add(ogretmen.toMap());
  }

  Future<List<Ogretmen>> ogretmenleriGetir() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('ogretmenler').get();

    return querySnapshot.docs.map((e) => Ogretmen.fromMap(e.data())).toList();
  }
}

final dataServiceProvider = Provider((ref) {
  return DataService();
});
