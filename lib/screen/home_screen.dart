import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuliner_jogja/screen/detail_screen.dart';
import 'package:kuliner_jogja/screen/edit_screen.dart';
import 'package:kuliner_jogja/screen/tambah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _listdata = [];
  bool _loading = true;

  Future _getdata() async {
    try {
      final respon = await http
          .get(Uri.parse('http://192.168.100.88/kuliner_jogja/read.php'));
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          _listdata = data;
          _loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    _getdata();
    super.initState();
  }

  Future _deletedata(String id) async {
    try {
      final respon = await http.post(
          Uri.parse('http://192.168.100.88/kuliner_jogja/delete.php'),
          body: {
            "id": id,
          });
      if (respon.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuliner Jogja"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            ListData: {
                              'nama': _listdata[index]['nama'],
                              'jenis': _listdata[index]['jenis'],
                              'deskripsi': _listdata[index]['deskripsi'],
                              'alamat': _listdata[index]['alamat'],
                              'foto': _listdata[index]['foto'],
                            },
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['nama']),
                      subtitle: Text(_listdata[index]['jenis']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditScreen(
                                            ListData: {
                                              'nama': _listdata[index]['nama'],
                                              'jenis': _listdata[index]
                                                  ['jenis'],
                                              'deskripsi': _listdata[index]
                                                  ['deskripsi'],
                                              'alamat': _listdata[index]
                                                  ['alamat'],
                                              'foto': _listdata[index]['foto'],
                                            },
                                          )));
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: Text(
                                          'Yakin ingin menghapus data ini?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _deletedata(_listdata[index]['id'])
                                                .then((value) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          HomeScreen())),
                                                  (route) => false);
                                            });
                                          },
                                          child: Text('Hapus'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Batal'),
                                        ),
                                      ],
                                    );
                                  }));
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TambahScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
