// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:alterindo/widgets/Navigation/history%20absen/component/data_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../setting/class_history.dart';

class HistoryAbsensi extends StatefulWidget {
  final String nip;

  const HistoryAbsensi({super.key, required this.nip});

  @override
  State<HistoryAbsensi> createState() => _HistoryAbsensiState();
}

class _HistoryAbsensiState extends State<HistoryAbsensi> {
  String _selectedOption = '';

  int status = 3;
  // ////////////////////////////////menene
  late Future<List<History>> dataHistory;
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime(3000);
  DateTime secondDate = DateTime(1945);
  bool refresh = false;

  // String nama = '';
  // String jabatan = '';
  // String foto = '';

  // void fetchUserData() async {
  //   final response = await http.get(
  //     Uri.parse(
  //       'https://www.mydeveloper.pro/hris/api.php?action=data_karyawan&id=${widget.nip}',
  //     ),
  //     headers: {
  //       'Authorization': 'Bearer 123456789',
  //     },
  //   );
  //   print('Status Code: ${response.statusCode}');
  //   print('Response Body: ${response.body}');

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> json = jsonDecode(response.body);
  //     print('Decoded JSON: $json');

  //     setState(() {
  //       nama = json['Nama'] ?? 'User is Null';
  //       jabatan = json['Jabatan'] ?? 'Jabatan Is Null';
  //       // foto = json['Foto'] ?? '';
  //     });
  //   } else {
  //     throw Exception('Failed to load user data');
  //   }
  // }

  void getFirstDate() {
    DateTime newDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    setState(() {
      lastDate = newDate;
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      dataHistory = fetchHistoryData();
      refresh = !refresh;
    });
  }

  @override
  void initState() {
    super.initState();
    getFirstDate();
    // fetchUserData();
    dataHistory = fetchHistoryData();
  }

  void firstDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary), // Warna tombol.
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != secondDate) {
      setState(() {
        secondDate = pickedDate; // Memperbarui tanggal awal.
        dataHistory =
            fetchHistoryData(); // Mengambil data baru berdasarkan tanggal.
        refresh = !refresh; // Mengatur ulang tampilan.
      });
      // onDateTimeChanged(pickedDate);
    }
  }

  void lastDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary), // Warna tombol.
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != secondDate) {
      setState(() {
        lastDate = pickedDate; // Memperbarui tanggal awal.
        dataHistory =
            fetchHistoryData(); // Mengambil data baru berdasarkan tanggal.
        refresh = !refresh; // Mengatur ulang tampilan.
      });
    }
  }

  // /////////////////////////////////////      //////////////////////////          /////
  Future<List<History>> fetchHistoryData() async {
    final url =
        'https://www.mydeveloper.pro/hris/api.php?action=data_absen_history&id=${widget.nip}&TanggalAwal=${DateFormat('yyyy-MM-dd').format(secondDate)}&TanggalAkhir=${DateFormat('yyyy-MM-dd').format(lastDate)}';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer 123456789',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        List<History> allData =
            jsonData.map((json) => History.fromJson(json)).toList();

        List<History> filteredData = allData.where((data) {
          if (status == 3) return true;

          if (data.keterangan == null ||
              data.keterangan == 'Data Keterangan Null') {
            return status == 4;
          }
          if (data.keterangan == 'Ijin Tidak Masuk') {
            return status == 1;
          }
          if (data.keterangan == 'Alpha') {
            return status == 2;
          }
          if (data.keterangan == 'Masuk') {
            return status == 0;
          }
          if (data.keterangan == 'Libur') {
            return status == 5;
          }

          return false;
        }).toList();

        return filteredData;
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  // tanggal manual
  void _showBottomSheet1(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          const Text(
                            'Pilih Tanggal',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ]),
                      ),
                      const SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          height: 1,
                          decoration: const BoxDecoration(
                            color: AppColors.grey,
                          )),
                      const SizedBox(height: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Dari Tanggal:"),
                          GestureDetector(
                            onTap: () {
                              firstDatePicker();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    lastDate != DateTime(3000)
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(lastDate)
                                        : 'Pick Date',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Sampai Tanggal:"),
                          GestureDetector(
                            onTap: () {
                              lastDatePicker();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    lastDate != DateTime(3000)
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(lastDate)
                                        : 'Pick Date',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 2),
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

// tanggal
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // container 1
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Text('Pilih Tanggal',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 24,
                              color: AppColors.secondary,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Container(
                        width: double.infinity,
                        height: 1,
                        decoration: const BoxDecoration(
                          color: AppColors.grey,
                        )),
                    const SizedBox(height: 8),
                    // container 2
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = 'Semua Tanggal';
                                    firstDate = DateTime.now();
                                    secondDate = DateTime(1900);
                                    lastDate = DateTime.now();
                                    dataHistory = fetchHistoryData();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Semua Tanggal'),
                                        if (_selectedOption == 'Semua Tanggal')
                                          const Icon(Icons.check,
                                              color: AppColors.secondary),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 7
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = '7 Hari Terakhir';
                                    secondDate = DateTime.now()
                                        .subtract(const Duration(days: 7));
                                    lastDate = DateTime.now();
                                    dataHistory = fetchHistoryData();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('7 Hari Terakhir'),
                                        if (_selectedOption ==
                                            '7 Hari Terakhir')
                                          const Icon(Icons.check,
                                              color: AppColors.secondary),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 30
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = '30 Hari Terakhir';
                                    secondDate = DateTime.now()
                                        .subtract(const Duration(days: 30));
                                    lastDate = DateTime.now();
                                    dataHistory = fetchHistoryData();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('30 Hari Terakhir'),
                                        if (_selectedOption ==
                                            '30 Hari Terakhir')
                                          const Icon(Icons.check,
                                              color: AppColors.secondary),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 60
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = '60 Hari Terakhir';
                                    secondDate = DateTime.now()
                                        .subtract(const Duration(days: 60));
                                    lastDate = DateTime.now();
                                    dataHistory = fetchHistoryData();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('60 Hari Terakhir'),
                                        if (_selectedOption ==
                                            '60 Hari Terakhir')
                                          const Icon(Icons.check,
                                              color: AppColors.secondary),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // GestureDetector Pilih
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showBottomSheet1(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Pilih'),
                                        Icon(Icons.arrow_forward_ios_rounded)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

// Status
  void _showBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text('Pilih Jenis Absensi',
                      style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: 24, color: AppColors.secondary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildStatusOption(context, 'Semua Status', 3),
              _buildStatusOption(context, 'Masuk', 0),
              _buildStatusOption(context, 'Izin', 1),
              _buildStatusOption(context, 'Alpha', 2),
              _buildStatusOption(context, 'Libur', 5),
              _buildStatusOption(context, 'Data Keterangan Null', 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext context, String label, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = label;
          status = value;
          dataHistory = fetchHistoryData();
        });
        Navigator.pop(context);
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),
              const Divider(),
              if (_selectedOption == label)
                const Icon(Icons.check, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            textAlign: TextAlign.center,
            'Histori Absensi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [],
              //   ),
              // ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: FutureBuilder<List<History>>(
                    future: dataHistory,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Gagal Mengambil Data'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return DataHistory(
                              tanggal: data.tanggal,
                              keterangan: data.keterangan,
                              jamMasuk: data.jamMasuk,
                              jamPulang: data.jamPulang,
                              foto: data.foto,
                              nama: data.nama,
                              ketBawah: data.status == 1
                                  ? '${data.keterangan} ${data.terlambat.isNotEmpty ? data.terlambat : data.toleransi.isNotEmpty ? data.toleransi : ''}'
                                  : data.keterangan,
                              shift: data.namaShift,
                              nip: widget.nip,
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('Tidak Ada Data Yang Ditemukan'));
                      }
                    },
                  ),
                ),
              ),

              // //////////////expanded
            ],
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20, height: 40),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: const SizedBox(
                    child: Row(children: [
                      Text('Tanggal'),
                      Icon(Icons.keyboard_arrow_down)
                    ]),
                  ),
                ),
                const Text('|'),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet2(context);
                  },
                  child: const SizedBox(
                    child: Row(children: [
                      Text('Status'),
                      Icon(Icons.keyboard_arrow_down)
                    ]),
                  ),
                ),
                const SizedBox(width: 20, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
