import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../component/color.dart';
import '../../../setting/class_history_izin.dart';
import 'component/data_history_izin.dart';
import 'component/detail_izin_page.dart';

class HistoryIzinPages extends StatefulWidget {
  final String nip;
  const HistoryIzinPages({super.key, required this.nip});

  @override
  State<HistoryIzinPages> createState() => _HistoryIzinPagesState();
}

class _HistoryIzinPagesState extends State<HistoryIzinPages> {
  String _selectedOption = '';

  late Future<List<HistoryIzin>> dataHistoryIzin;
  String nama = '';
  String jabatan = '';
  String foto = '';

  // String image = '';

  int status = 3;
  int tanggal = 3;
  bool refresh = false;

  DateTime startDate = DateTime(1900);
  DateTime endDate = DateTime(3000);
  DateTime dateNow = DateTime.now();

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
                                    startDate != null
                                        ? 'Pick Date'
                                        :DateFormat('dd-MM-yyyy')
                                            .format(startDate) ,
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
                                    endDate != null
                                        ?  'Pick Date'
                                        :DateFormat('dd-MM-yyyy')
                                            .format(endDate),
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
                                    startDate = DateTime(1900);
                                    endDate = DateTime(3000);
                                  });
                                  Navigator.pop(context);
                                  dataHistoryIzin = fetchHistoryData();
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
                                    startDate = DateTime.now()
                                        .subtract(const Duration(days: 7));
                                    endDate = DateTime.now();
                                  });
                                  Navigator.pop(context);
                                  dataHistoryIzin = fetchHistoryData();
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
                                    startDate = DateTime.now()
                                        .subtract(const Duration(days: 30));
                                    endDate = DateTime.now();
                                  });
                                  Navigator.pop(context);
                                  dataHistoryIzin = fetchHistoryData();
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
                                    startDate = DateTime.now().subtract(const Duration(days: 60));
                                    endDate = DateTime.now();
                                  });
                                  Navigator.pop(context);
                                  dataHistoryIzin = fetchHistoryData();
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
                        const Text('Pilih Jenis Absensi',
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  // container 2
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOption = 'Semua Status';
                              status = 3;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 6),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Semua Status'),
                                    if (_selectedOption == 'Semua Status')
                                      const Icon(Icons.check,
                                          color: AppColors.secondary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOption = 'Pending';
                              status = 0;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 6),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Pending'),
                                    if (_selectedOption == 'Pending')
                                      const Icon(Icons.check,
                                          color: AppColors.secondary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOption = 'Accepted';
                              status = 1;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 6),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Accepted'),
                                    if (_selectedOption == 'Accepted')
                                      const Icon(Icons.check,
                                          color: AppColors.secondary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOption = 'Denied';
                              status = 2;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 6),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Denied'),
                                    if (_selectedOption == 'Denied')
                                      const Icon(Icons.check,
                                          color: AppColors.secondary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void firstDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: startDate,
      lastDate: endDate,
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

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate; // Memperbarui tanggal awal.
        dataHistoryIzin =
            fetchHistoryData(); // Mengambil data baru berdasarkan tanggal.
        refresh = !refresh; // Mengatur ulang tampilan.
      });
      // onDateTimeChanged(pickedDate);
    }
  }

  void lastDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: startDate,
      lastDate: endDate,
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

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        endDate = pickedDate; // Memperbarui tanggal awal.
        dataHistoryIzin =
            fetchHistoryData(); // Mengambil data baru berdasarkan tanggal.
        refresh = !refresh; // Mengatur ulang tampilan.
      });
    }
  }

  // /////////////////////////////////////  done    //////////////////////////          /////
  void getFirstDate() {
    DateTime newDate = DateTime(dateNow.year, dateNow.month, dateNow.day);
    setState(() {
      dateNow = newDate;
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    dataHistoryIzin = fetchHistoryData();
    setState(() {}); // Memperbarui tampilan.
  }

  void fetchUserData() async {
    final response = await http.get(
      Uri.parse(
        'https://alterindo.com/hris/api.php?action=login&id=${widget.nip}',
      ),
      headers: {
        'Authorization': 'Bearer R8pZ5kL7QwX3J0aH2cT9vFm4Yn6bV1g',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      setState(() {
        nama = json['Nama'] ?? 'User is Null';
        jabatan = json['Jabatan'] ?? 'Jabatan Is NUll';
      });
    } else {
      log('Failed Load User Data');
    }
  }

  Future<List<HistoryIzin>> fetchHistoryData() async {
    final response = await http.get(
      Uri.parse(
        'https://alterindo.com/hris/api.php?action=data_pengajuan_izin&Kode=${widget.nip}&TanggalAwal=${DateFormat('yyyy-MM-dd').format(startDate)}&TanggalAkhir=${DateFormat('yyyy-MM-dd').format(endDate)}',
      ),
      headers: {
        'Authorization': 'Bearer R8pZ5kL7QwX3J0aH2cT9vFm4Yn6bV1g',
      },
    );
    if (response.statusCode == 200) {
      log(response.body);
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => HistoryIzin.fromJson(json)).toList();
    } else {
      log(response.body);
      throw Exception('Gagal Untuk Mengambil Data');
    }
  }

  @override
  void initState() {
    super.initState();
    getFirstDate();
    fetchUserData();
    
    dataHistoryIzin = fetchHistoryData();
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
            'Histori Pengajuan Izin',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      Text('Semua Tanggal'),
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
                      Text('Semua Status'),
                      Icon(Icons.keyboard_arrow_down)
                    ]),
                  ),
                ),
                const SizedBox(width: 20, height: 20),
              ],
            ),
          ),
          // ////////////////////////////////////////////////////////////
          // //////////////////////////////////
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: FutureBuilder<List<HistoryIzin>>(
                future: dataHistoryIzin,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Gagal Untuk Mengambil Data',
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return Visibility(
                          visible: data.otorisasi == status || status == 3,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return DetailIzinPage(
                                      userOtorisasi: data.userOtorisasi,
                                      kodeUnik: data.kodeUnik,
                                      keteranganOtorisasi:
                                          data.keteranganOtorisasi,
                                      jenis: data.jenisIzin,
                                      tanggal: data.tanggal,
                                      uraian: data.keterangan,
                                      foto: data.foto,
                                      nama: nama,
                                      pdf: data.dokumen,
                                      otorisasi: data.otorisasi,
                                    );
                                  },
                                ),
                              );
                            },
                            child: DataHistoryIzin(
                              tanggal: data.tanggal,
                              jenis: data.jenisIzin,
                              keterangan: data.keterangan,
                              userOtorisasi: data.userOtorisasi,
                              otorisasi: data.otorisasi,
                              keteranganOtorisasi: data.keteranganOtorisasi,
                              kodeUnik: data.kodeUnik,
                              foto: data.foto,
                              dokumen: data.dokumen,
                              nama: nama,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Tidak Ada Data Yang Ditemukan'),
                    );
                  }
                },
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
