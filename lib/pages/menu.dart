import 'dart:convert';

import 'package:alterindo/widgets/Navigation/absensi/absen_pages.dart';
import 'package:alterindo/widgets/Navigation/history%20absen/history_absensi.dart';
import 'package:alterindo/widgets/Navigation/history_cuti/history_cuti.dart';
import 'package:alterindo/widgets/Navigation/cuti/pengajuan_cuti.dart';
import 'package:alterindo/widgets/Navigation/Izin/pengajuan_izin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../component/color.dart';
import '../widgets/Navigation/history_izin/history_izin.dart';

class MenuPages extends StatefulWidget {
  final String nip;
  final String device;
  const MenuPages({super.key, required this.nip, required this.device});

  @override
  State<MenuPages> createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> {
  String nama = 'USER';
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
          nama = json[0]['Nama'] ?? 'Gagal Mengambil User';
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 0.001, blurRadius: 5),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbsenPages(
                              nip: widget.nip,
                              device: widget.device,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Image.asset('assets/avatars/jam.png'),
                        ),
                      ),
                    ),
                    const Text('Absensi\n  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  HistoryAbsensi(nip: widget.nip,),
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child:
                              Image.asset('assets/avatars/history absen.png'),
                        ),
                      ),
                    ),
                    const Text('Histori\nAbsensi',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  PengajuanIzin(nip: widget.nip, nama: nama, )));
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Image.asset('assets/avatars/izin.png'),
                        ),
                      ),
                    ),
                    const Text('Pengajuan\nIzin',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PengajuanCuti(nip: widget.nip,),
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child:
                              Image.asset('assets/avatars/kalender cuti.png'),
                        ),
                      ),
                    ),
                    const Text('Pengajuan\nCuti',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryIzinPages(nip: widget.nip,)));
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Image.asset(
                              'assets/avatars/history cuti dan izin.png'),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text('Histori\nPengajuan\nIzin',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    )
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryCutiPages(nip: widget.nip,)));
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: AppColors.bluegrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Image.asset(
                              'assets/avatars/history cuti dan izin.png'),
                        ),
                      ),
                    ),
                    const Text('Histori\nPengajuan\nCuti',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
                const SizedBox(height: 45, width: 80),
                const SizedBox(height: 45, width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
