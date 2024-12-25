import 'dart:convert';

import 'package:alterindo/widgets/login_screen.dart';
import 'package:alterindo/widgets/profile_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../component/color.dart';
import '../pages/kalendar.dart';
import '../pages/menu.dart';
import '../pages/timer.dart';
import 'halaman_setting.dart';

class HomePages extends StatefulWidget {
  final String nip;
  final String device;
  const HomePages({super.key, required this.nip, required this.device});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
// https://alterindo.com/hris/api.php?action=login&id=${widget.nip}
  String nama = 'USER';
  String foto = '';
  String jabatan = '';

  void getUserData() async {

      final response = await http.get(
        Uri.parse(
          'https://alterindo.com/hris/api.php?action=data_karyawan&id=${widget.nip}',
        ),
        headers: {
          'Authorization': 'Bearer R8pZ5kL7QwX3J0aH2cT9vFm4Yn6bV1g',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        setState(() {
          nama = json[0]['Nama'] ?? 'Gagal Mengambil User';
          jabatan = json[0]['Jabatan'] ?? '';
          foto = json[0]['Foto'] ?? '';
        });
      } else {
        throw Exception('Failed Load User Data');
      }
  }
Future<void> checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('status') ?? false;
  if (!status) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
  @override
  void initState() {
    super.initState();
    getUserData();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 320),
                    MenuPages(
                      nip: widget.nip,
                      device: widget.device,
                    ),
                    const SizedBox(height: 20),
                    Kalendar(nip : widget.nip),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          // ////////////////////////////////////////////////////////////////// up to container, down to app bar
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/Background App Bar (1).png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 24,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'PT. Alterindo Software',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          )),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert_outlined,
                        ),
                        color: Colors.white,
                        iconSize: 29,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanSetting(
                                nip: widget.nip,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          jabatan,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        MaterialPageRoute(builder: (context) => ProfilePages(nip: widget.nip,));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: foto.isEmpty
                              ? Center(
                                  child: Text(
                                    nama.isEmpty ? '' : nama[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ClipOval(
                                  child: Image.memory(
                                    base64Decode(foto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                TimePages(),
              ],
            ),
          ), //padding batas
        ],
      ),
    );
  }
}
