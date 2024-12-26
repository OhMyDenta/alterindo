import 'dart:convert';

import 'package:alterindo/widgets/login_screen.dart';
import 'package:alterindo/widgets/profile_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/color.dart';

class HalamanSetting extends StatefulWidget {
  final String nip;
  const HalamanSetting({super.key, required this.nip});

  @override
  State<HalamanSetting> createState() => _HalamanSettingState();
}

class _HalamanSettingState extends State<HalamanSetting> {
  String nama = '';
  String jabatan = '';
  String foto = '';

  Future<void> delPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', false);
    await prefs.setString('nip', '');
    await prefs.setString('device', '');
  }

  void fetchUserData() async {
    try {
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
    } catch (e) {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                width: double.infinity,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nama),
                          Text(jabatan),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        delPref();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ProfilePages(nip: widget.nip);
                    }),
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin_sharp,
                          size: 12,
                          color: AppColors.secondary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Personal Informastion'),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: 12,
                      color: AppColors.secondary,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Version'),
                    Spacer(),
                    Text('V 1.0.0'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
