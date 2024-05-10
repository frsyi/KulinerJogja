import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:kuliner_jogja/screen/home_screen.dart';
import 'package:kuliner_jogja/screen/map_screen.dart';

class EditScreen extends StatefulWidget {
  final Map ListData;
  const EditScreen({super.key, required this.ListData});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  String _jenis = 'makanan';

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future _editdata() async {
    if (_image == null) {
      final snackBar = SnackBar(content: Text('Pilih foto terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    // Ubah file gambar menjadi byte array
    List<int> imageBytes = await _image!.readAsBytes();

    // Konversi byte array menjadi base64
    String base64Image = base64Encode(imageBytes);

    final respon = await http
        .post(Uri.parse('http://192.168.100.88/kuliner_jogja/edit.php'), body: {
      'nama': _namaController.text,
      'jenis': _jenis,
      'deskripsi': _deskripsiController.text,
      'foto': base64Image,
    });
    if (respon.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _namaController.text = widget.ListData['nama'];
    _jenis = widget.ListData['jenis'];
    _deskripsiController.text = widget.ListData['deskripsi'];
    _alamat = widget.ListData['alamat'];
    _image = widget.ListData['foto'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kuliner'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nama Kuliner",
                      hintText: "Masukkan Nama Kuliner",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama kuliner tidak boleh kosong";
                      }
                    },
                    controller: _namaController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('Jenis Kuliner:'),
                      Radio<String>(
                        value: 'makanan',
                        groupValue: _jenis,
                        onChanged: (value) {
                          setState(() {
                            _jenis = value!;
                          });
                        },
                      ),
                      const Text('Makanan'),
                      Radio<String>(
                        value: 'minuman',
                        groupValue: _jenis,
                        onChanged: (value) {
                          setState(() {
                            _jenis = value!;
                          });
                        },
                      ),
                      const Text('Minuman'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Deskripsi Kuliner",
                      hintText: "Masukkan Deskripsi Kuliner",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Deskripsi kuliner tidak boleh kosong";
                      }
                    },
                    controller: _deskripsiController,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Alamat"),
                      _alamat == null
                          ? const SizedBox(
                              width: double.infinity,
                              child: Text('Alamat Kosong'))
                          : Text('$_alamat'),
                      _alamat == null
                          ? TextButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                        onLocationSelected: (selectedAddress) {
                                      setState(() {
                                        _alamat = selectedAddress;
                                      });
                                    }),
                                  ),
                                );
                              },
                              child: const Text('Pilih Alamat'))
                          : TextButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                        onLocationSelected: (selectedAddress) {
                                      setState(() {
                                        _alamat = selectedAddress;
                                      });
                                    }),
                                  ),
                                );
                                setState(() {});
                              },
                              child: const Text('Ubah Alamat'),
                            )
                    ],
                  ),
                ),
                _image == null
                    ? const Text('Tidak ada gambar yang dipilih.')
                    : Image.file(_image!),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: getImage, child: const Text("Pilih Gambar")),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _editdata().then((value) {
                          if (value) {
                            final snackBar =
                                SnackBar(content: Text('Data berhasil diedit'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar =
                                SnackBar(content: Text('Data gagal diedit'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
