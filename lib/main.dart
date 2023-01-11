import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogrenci_uyg/pages/mesajlar_sayfasi.dart';
import 'package:ogrenci_uyg/pages/ogrenciler_sayfasi.dart';
import 'package:ogrenci_uyg/pages/ogretmenler_sayfasi.dart';
import 'package:ogrenci_uyg/repository/mesajlar_repository.dart';
import 'package:ogrenci_uyg/repository/ogrenciler_repository.dart';
import 'package:ogrenci_uyg/repository/ogretmenler_repository.dart';

void main() {
  runApp(const ProviderScope(child: OgrenciUyg()));
}

class OgrenciUyg extends StatelessWidget {
  const OgrenciUyg({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenci Uygulaması ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnaSayfa(title: 'Öğrenci Ana Sayfa'),
    );
  }
}

class AnaSayfa extends ConsumerWidget {
  const AnaSayfa({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ogrencilerRepository = ref.watch(ogrencilerProvider);
    final ogretmenlerRepository = ref.watch(ogretmenlerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  _mesajlaraGit(context);
                },
                child: Text(
                    '${ref.watch(yeniMesajSayisiProvider)} yeni mesaj var')),
            TextButton(
                onPressed: () {
                  _ogrencilereGit(context);
                },
                child:
                    Text('${ogrencilerRepository.ogrenciler.length} öğrenci')),
            TextButton(
                onPressed: () {
                  _ogretmenlereGit(context);
                },
                child: Text(
                    '${ogretmenlerRepository.ogretmenler.length} öğretmen')),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Öğrenci Adı'),
            ),
            ListTile(
              title: const Text('Öğrenciler'),
              onTap: () {
                _ogrencilereGit(context);
              },
            ),
            ListTile(
              title: const Text('Öğretmenler'),
              onTap: () {
                _ogretmenlereGit(context);
              },
            ),
            ListTile(
              title: const Text('Mesajlar'),
              onTap: () {
                _mesajlaraGit(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _ogrencilereGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const OgrencilerSayfasi();
      },
    ));
  }

  void _ogretmenlereGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const OgretmenlerSayfasi();
      },
    ));
  }

  Future<void> _mesajlaraGit(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const MesajlarSayfasi();
      },
    ));
  }
}
