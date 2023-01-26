import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ogrenci_uyg/pages/mesajlar_sayfasi.dart';
import 'package:ogrenci_uyg/pages/ogrenciler_sayfasi.dart';
import 'package:ogrenci_uyg/pages/ogretmenler_sayfasi.dart';
import 'package:ogrenci_uyg/repository/mesajlar_repository.dart';
import 'package:ogrenci_uyg/repository/ogrenciler_repository.dart';
import 'package:ogrenci_uyg/repository/ogretmenler_repository.dart';
import 'package:ogrenci_uyg/ultilies/google_sign_in.dart';

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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirebaseInitialized = false;
  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isFirebaseInitialized = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      anaSayfayaGit();
    }
  }

  void anaSayfayaGit() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AnaSayfa(title: 'Öğrenci Ana Sayfa'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isFirebaseInitialized
            ? ElevatedButton(
                onPressed: () async {
                  await signInWithGoogle();

                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('kullanıcılar')
                      .doc(uid)
                      .set(
                    {
                      'girişYaptiMi': true,
                      'sonGirisTarihi': FieldValue.serverTimestamp(),
                    },
                    SetOptions(merge: true),
                  );

                  anaSayfayaGit();
                },
                child: const Text('Google Sign In'))
            : const CircularProgressIndicator(),
      ),
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
            const UserHeader(),
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
            ListTile(
              title: const Text('Çıkış yap'),
              onTap: () async {
                await singOutWithGoogle();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
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

class UserHeader extends StatefulWidget {
  const UserHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  Future<Uint8List?>? _ppicFuture;
  @override
  void initState() {
    super.initState();
    _ppicFuture = _ppicIndir();
  }

  Future<Uint8List?> _ppicIndir() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('kullanıcılar')
        .doc(uid)
        .get();

    final userRecMap = documentSnapshot.data();
    if (userRecMap == null) return null;

    if (userRecMap.containsKey('ppicref')) {
      Uint8List? uint8list =
          await FirebaseStorage.instance.ref(userRecMap['ppicref']).getData();
      return uint8list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FirebaseAuth.instance.currentUser!.displayName!),
          Text(FirebaseAuth.instance.currentUser!.email!),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              XFile? xFile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (xFile == null) return;

              final imagePath = xFile.path;

              final uid = FirebaseAuth.instance.currentUser!.uid;

              final ppicRef =
                  FirebaseStorage.instance.ref('ppics').child('$uid.jpg');
              await ppicRef.putFile(File(imagePath));

              await FirebaseFirestore.instance
                  .collection('kullanıcılar')
                  .doc(uid)
                  .update({'ppicref': ppicRef.fullPath});

              setState(() {
                _ppicFuture = _ppicIndir();
              });
            },
            child: FutureBuilder<Uint8List?>(
                future: _ppicFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final picInMemory = snapshot.data!;
                    return MovingAvatar(picInMemory: picInMemory);
                  }
                  return const CircleAvatar(
                    child: Text('BD'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class MovingAvatar extends StatefulWidget {
  const MovingAvatar({
    Key? key,
    required this.picInMemory,
  }) : super(key: key);

  final Uint8List picInMemory;

  @override
  State<MovingAvatar> createState() => _MovingAvatarState();
}

class _MovingAvatarState extends State<MovingAvatar>
    with SingleTickerProviderStateMixin<MovingAvatar> {
  late Ticker _ticker;

  double yataydaKonum = 0.0;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      final aci = pi *
          elapsed.inMicroseconds /
          const Duration(seconds: 1).inMicroseconds;

      setState(() {
        yataydaKonum = sin(aci) * 30 + 30;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: yataydaKonum),
      child: CircleAvatar(
        backgroundImage: MemoryImage(widget.picInMemory),
      ),
    );
  }
}
