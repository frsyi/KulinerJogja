import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  final Map ListData;
  DetailScreen({Key? key, required this.ListData}) : super(key: key);
  // const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  String _jenis = 'Makanan';

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _namaController.text = widget.ListData['nama'];
    _jenis = widget.ListData['jenis'];
    _deskripsiController.text = widget.ListData['deskripsi'];
    _alamat = widget.ListData['alamat'];
    _image = widget.ListData['foto'];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Detail Kuliner")),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Nama Kuliner'),
                  subtitle: Text(widget.ListData['nama']),
                ),
                ListTile(
                  title: const Text('Jenis'),
                  subtitle: Text(widget.ListData['jenis']),
                ),
                ListTile(
                  title: const Text('Deskripsi Kuliner'),
                  subtitle: Text(widget.ListData['deskripsi']),
                ),
                ListTile(
                  title: const Text('Lokasi'),
                  subtitle: Text(widget.ListData['alamat']),
                ),
                _image == null
                    ? const Text('Tidak ada gambar yang dipilih.')
                    : Image.file(_image!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
