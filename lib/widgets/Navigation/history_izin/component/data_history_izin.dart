// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

import '../../../../component/color.dart';

class DataHistoryIzin extends StatefulWidget {
  final String id;
  final String nip;
  final String tanggal;
  final String jenis;
  final String keterangan;
  final String userOtorisasi;
  final int otorisasi;
  final String keteranganOtorisasi;
  final String kodeUnik;
  final String foto;
  final String dokumen;
   final Function onDelete;

  final String nama;
  const DataHistoryIzin({
    super.key,
    required this.id,
    required this.nip,
    required this.tanggal,
    required this.jenis,
    required this.keterangan,
    required this.userOtorisasi,
    required this.otorisasi,
    required this.foto,
    required this.keteranganOtorisasi,
    required this.kodeUnik,
    required this.dokumen,
    required this.nama, required this.onDelete,
  });

  @override
  State<DataHistoryIzin> createState() => _DataHistoryIzinState();
}

class _DataHistoryIzinState extends State<DataHistoryIzin> {
  // DateTime startDate = DateTime(1900);
  // DateTime endDate = DateTime(3000);
  // DateTime dateNow = DateTime.now();
  // Future<void> _deleteIzin(String id, String tanggal) async {
  //   try {
  //     final response = await http.post(
  //         Uri.parse(
  //             'https://www.mydeveloper.pro/hris/api.php?action=hapus_izin'),
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer 123456789",
  //         },
  //         body: {
  //           'id': id,
  //           'nip': widget.nip,
  //           'tanggal': tanggal,
  //         });
  //     print("Response Status: ${response.statusCode}");
  //     print("Response Body: ${response.body}");
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Pengajuan izin berhasil dihapus")),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Gagal menghapus izin: ${response.body}")),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Terjadi kesalahan saat menghapus izin")),
  //     );
  //   }
  // }

  // void _confirmDelete(BuildContext context, String id, String tanggal) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Konfirmasi Hapus"),
  //       content: const Text("Apakah Anda yakin ingin menghapus pengajuan ini?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Batal"),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             _deleteIzin(id, tanggal);
  //           },
  //           child: const Text("Hapus", style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(children: [
                          const Icon(Icons.calendar_month,
                              color: AppColors.secondary, size: 14),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.tanggal,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.center,
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                              color: widget.otorisasi == 0
                                  ? AppColors.threeorange
                                  : widget.otorisasi == 1
                                      ? AppColors.three
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Text(
                                widget.otorisasi == 0
                                    ? 'Pending'
                                    : widget.otorisasi == 1
                                        ? 'Accepted'
                                        : 'Deined',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: widget.otorisasi == 0
                                      ? Colors.white
                                      : widget.otorisasi == 1
                                          ? Colors.white
                                          : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: AppColors.secondary, size: 14),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.jenis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ket: '),
                            Expanded(
                                child: Text(widget.keterangan, softWrap: true)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(children: [
                          Row(children: [
                            //  container foto
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  widget.nama[0],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.nama,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          if (widget.otorisasi == 0)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          widget.onDelete(); // Panggil fungsi hapus
                        },
                      ),
                    ),
                        ]),
                      ),
                      ListTile(
                        title: Text(widget.jenis),
                        subtitle: Text(widget.tanggal),
                        
                        // trailing: widget.otorisasi ==
                        //         0 // Tombol hanya muncul jika status Pending
                        //     ? IconButton(
                        //         icon:
                        //             const Icon(Icons.delete, color: Colors.red),
                        //         onPressed: () => _confirmDelete(
                        //             context, widget.id, widget.tanggal),
                        //       )
                        //     : null,
                      ),
                    ]),
              ))
        ],
      ),
    );
  }
}
