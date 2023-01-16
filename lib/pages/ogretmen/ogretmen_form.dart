import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogrenci_uyg/models/ogretmen.dart';
import 'package:ogrenci_uyg/services/data_service.dart';

class OgretmenForm extends ConsumerStatefulWidget {
  const OgretmenForm({Key? key}) : super(key: key);

  @override
  _OgretmenFormState createState() => _OgretmenFormState();
}

class _OgretmenFormState extends ConsumerState<OgretmenForm> {
  final Map<String, dynamic> girilen = {};
  final _formKey = GlobalKey<FormState>();

  bool isSaving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Öğretmen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Ad'),
                  ),
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Ad girmeniz gerekli';
                    }
                  },
                  onSaved: (newValue) {
                    girilen['ad'] = newValue;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Soyad'),
                  ),
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Soyad girmeniz gerekli';
                    }
                  },
                  onSaved: (newValue) {
                    girilen['soyad'] = newValue;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Yaş'),
                  ),
                  validator: (value) {
                    if (value == null || value.isNotEmpty != true) {
                      return 'Yaş girmeniz gerekli';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Rakamlarla yaş girmeniz gerekli.';
                    }
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    girilen['yas'] = int.parse(newValue!);
                  },
                ),
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                      child: Text('Erkek'),
                      value: 'Erkek',
                    ),
                    DropdownMenuItem(
                      child: Text('Kadın'),
                      value: 'Kadın',
                    ),
                  ],
                  value: girilen['cinsiyet'],
                  onChanged: (value) {
                    setState(() {
                      girilen['cinsiyet'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Lütfen cinsiyet seçiniz';
                    }
                  },
                ),
                if (isSaving)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                      onPressed: () {
                        final formState = _formKey.currentState;
                        if (formState == null) return;
                        if (formState.validate() == true) {
                          formState.save();
                          print(girilen);
                        }
                        _kaydet();
                      },
                      child: const Text('Kaydet'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _kaydet() async {
    bool bitti = false;
    while (!bitti) {
      try {
        setState(() {
          isSaving = true;
        });

        await gercektenKaydet();
        bitti = true;
        Navigator.of(context).pop(true);
      } catch (e) {
        final snackBar = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
        await snackBar.closed;
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  int i = 0;
  Future<void> gercektenKaydet() async {
    i++;
    if (i < 3) {
      throw 'Kayıt yapılamadı.';
    }
    await ref.read(dataServiceProvider).ogretmenEkle(Ogretmen.fromMap(girilen));
  }
}
