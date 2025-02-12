import 'dart:convert';

import 'package:alterindo/component/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePages extends StatefulWidget {
  final String nip;
  const ProfilePages({super.key, required this.nip});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  String nama = '';
  String noTelpon = '';
  String alamat = '';
  String jabatan = '';
  String divisi = '';
  String foto = '';

  void fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.mydeveloper.pro/hris/api.php?action=data_karyawan&id=${widget.nip}',
        ),
        headers: {
          'Authorization': 'Bearer 123456789',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        setState(() {
          nama = json[0]['Nama'] ?? 'User Is Null';
          alamat = json[0]['Alamat'] ?? 'Alamat Is Null';
          jabatan = json[0]['Jabatan'] ?? 'Jabatan Is Null';
          noTelpon = json[0]['HP'] ?? 'Nomer Telpon Is Null';
          divisi = json[0]['Divisi'] ?? 'Divisi Is Null';
          foto = json[0]['Foto'] ?? '';
        });
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('error');
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
          title: const Text(
            'Profile Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                // NIP
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NIP',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.supervised_user_circle,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.nip,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // nama
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              nama,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // nomer
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No. Telepon',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.call,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              noTelpon,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // alamat
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alamat',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                alamat,
                                style: const TextStyle(fontSize: 14),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // jabatan
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jabatan',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium_outlined,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              jabatan,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // divisi
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Divisi',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.maps_home_work_sharp,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              divisi,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // Foto
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foto profil',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Visibility(
                          visible: foto.isNotEmpty,
                          child: Container(
                            width: 150,
                            height: 200,
                            color: Colors.grey[200],
                            child: Image.memory(
                              base64Decode(foto),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
