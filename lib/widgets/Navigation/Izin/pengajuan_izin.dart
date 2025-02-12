// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alterindo/pages/pdf.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../pages/bottom_notif_gagal.dart';
import '../../../setting/class_pengajuan.dart';

class PengajuanIzin extends StatefulWidget {
  final String nip;
  final String nama;

  const PengajuanIzin({
    super.key,
    required this.nip,
    required this.nama,
  });

  @override
  State<PengajuanIzin> createState() => _PengajuanIzinState();
}

class _PengajuanIzinState extends State<PengajuanIzin> {
  TextEditingController _keterangan = TextEditingController();
  late Future<List<Pengajuan>> dataIzin;

  File? foto;
  File? file;

  bool selected = false;
  DateTime dateNow = DateTime.now();

  bool isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  String izin = 'Pilih Disini';
  String izinCode = '0000';

  String nama = '';
  String jabatan = '';
  String fotop = '';

  void fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.mydeveloper.pro/hris/api.php?action=login&id=${widget.nip}',
        ),
        headers: {
          'Authorization': 'Bearer 123456789',
        },
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('Decoded JSON: $json');

        if (json.isNotEmpty) {
          setState(() {
            nama = json['Nama'] ?? 'User is Null';
            jabatan = json['Jabatan'] ?? 'Jabatan Is Null';
            fotop = json['Foto'] ?? '';
          });
        } else {
          throw Exception('Empty data from API');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Pengajuan>> fetchHistoryData() async {
    final response = await http.get(
      Uri.parse(
        'https://www.mydeveloper.pro/hris/api.php?action=data_ijin',
      ),
      headers: {
        'Authorization': 'Bearer 123456789',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Pengajuan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal Untuk Mengambil Data');
    }
  }

// pick date
  void datePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != dateNow) {
      setState(() {
        dateNow = selectedDate;
      });
    }
  }

  void deleteContext(
    String title,
    String subtitle,
    void Function() fun,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              subtitle,
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        child: Center(
                          child: Text(
                            'TIDAK',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: fun,
                      child: const SizedBox(
                        child: Center(
                          child: Text(
                            'YA',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// all ready
  void _showFileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (foto != null) {
                      return deleteContext(
                        'Gambar Sudah Ada!',
                        'Tindakan Ini Akan Menggati\nGambar Anda',
                        imagePicker,
                      );
                    } else {
                      imagePicker();
                    }
                  },
                  child: const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Image',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (file != null) {
                      return deleteContext(
                        'PDF Sudah Ada!',
                        'Tindakan Ini Akan Menggati\nFile PDF Yang Ada',
                        pickFile,
                      );
                    } else {
                      pickFile();
                    }
                  },
                  child: const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'PDF',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'BATAL',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

// send request pengajuan
  void sendRequest(
    String tanggal,
    String kode,
    String jenis,
    String keterangan,
    File? foto,
    File? file,
  ) async {
    try {
      final formData = FormData.fromMap({
        'Tanggal': tanggal,
        'Kode': kode,
        'Jenis': jenis,
        'Keterangan': keterangan,
        if (foto != null)
          'foto': await MultipartFile.fromFile(
            foto.path,
            filename: '${DateTime.now()}.jpg',
          ),
        if (file != null)
          'dokumen': await MultipartFile.fromFile(
            file.path,
            filename: '${DateTime.now()}.pdf',
          ),
      });

      final response = await Dio().post(
        'https://www.mydeveloper.pro/hris/api.php?action=insert_ijin',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer 123456789',
          },
        ),
      );

      if (mounted) {
        Navigator.pop(context);
        setState(() {
          foto = null;
          file = null;
          izinCode = '0000';
          izin = 'Pilih Disini';
          _keterangan = TextEditingController();
        });
        _showBottomSheet(context);
      }

      log('''Status Code: ${response.statusCode}
Response Body: ${response.data}''');
    } catch (e) {
      log('Error: $e');
      bottomSheetGagal(
        context: context,
        title: 'Gagal Mengajukan Izin',
        subtitle: 'Silahkan Melengkapi Data',
      );
    }
  }

  void pilihIzin() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Pilih Jenis Ijin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: FutureBuilder<List<Pengajuan>>(
                  future: dataIzin,
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
                          return InkWell(
                            onTap: () {
                              setState(() {
                                izin = data.nama;
                                izinCode = data.kode;
                              });
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    data.nama,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
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
            ],
          ),
        );
      },
    );
  }

// ////////////////////
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    String filePath = result.files.single.path!;
    setState(() => file = File(filePath));
  }

  void imagePicker() async {
    final imageData =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageData == null) return;
    setState(() {
      foto = File(imageData.path);
    });
  }
// //////////////////////

// kirim pengajuan
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              )),
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_sharp,
                      color: AppColors.three,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text('Pengajuan Izin Berhasil',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22)),
                    const SizedBox(height: 8),
                    const Text('Menunggu Otorisasi',
                        style: TextStyle(color: AppColors.three, fontSize: 12)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 22),
                            child: Text('OK',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          )),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    dataIzin = fetchHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (izinCode != '0000' ||
                foto != null ||
                file != null ||
                _keterangan.text != '') {
              deleteContext(
                'Keluar Halaman?',
                'Tindakan Ini Akan Menghapus\nData Yang Kamu Tambahkan',
                () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengajuan Izin',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
                // textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: const Text(
                          'Data Pemohonan Izin',
                          style: TextStyle(color: Colors.white),
                        ),
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // container data dengan NIP, Nama, Jabatan, dan foto
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('NIP',
                                            style: TextStyle(fontSize: 12)),
                                        Text(widget.nip,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 5),
                                        const Text('Nama',
                                            style: TextStyle(fontSize: 12)),
                                        Text(nama,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 5),
                                        const Text('Jabatan',
                                            style: TextStyle(fontSize: 12)),
                                        Text(jabatan,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                    Container(
                                      height: 80,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      child: fotop != null && fotop.isNotEmpty
                                          ? ClipRRect(
                                              child: Image.network(
                                              fotop,
                                              fit: BoxFit.cover,
                                            ))
                                          : Center(
                                              child: Text(
                                                widget.nama[0],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pilihIzin,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jenis',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12),
                                child: Row(children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 20, color: AppColors.secondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    izin,
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 14),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down,
                                      size: 20, color: AppColors.secondary),
                                ]),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: datePicker,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tanggal Izin',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12),
                                child: Row(children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 20, color: AppColors.secondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    dateNow == null
                                        ? 'Pilih Disini'
                                        : DateFormat('dd-MM-yyyy')
                                            .format(dateNow),
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 14),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down,
                                      size: 20, color: AppColors.secondary),
                                ]),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //keterangan
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Keterangan',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(12)),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  textAlign: TextAlign.start,
                                  controller: _keterangan,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      hintText:
                                          'Saya Mengajukan Izin... \nDikarenakan...'),
                                  minLines: 1,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // foto file
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("File Pendukung",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            icon: const Icon(Icons.upload_file_rounded,
                                color: AppColors.secondary),
                            label: const Text("Upload File",
                                style: TextStyle(color: AppColors.secondary)),
                            onPressed: _showFileOptions,
                          ),
                          Visibility(
                            visible: file != null || foto != null,
                            child: Container(
                              height: 8,
                            ),
                          ),
                          Visibility(
                            visible: file != null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Pdf(
                                          pdfData: '',
                                          file: file,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    const SizedBox(width: 10),
                                    const Text('File PDF Telah Terkait'),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        deleteContext(
                                          'Hapus PDF?',
                                          'Apakah Kamu Yakin\nMenghapus file PDF?',
                                          () {
                                            setState(() => file = null);
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: foto != null,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  foto != null
                                      ? Image.file(foto!)
                                      : const SizedBox(),
                                  IconButton(
                                    onPressed: () {
                                      deleteContext(
                                        'Hapus Gambar?',
                                        'Apa Kamu Yakin Ingin\nMenghapus Gambar',
                                        () {
                                          setState(() => foto = null);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    icon: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.75),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // tombol

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  if (izinCode == '0000') {
                    bottomSheetGagal(
                        context: context,
                        title: 'Data Pengajuan kosong',
                        subtitle: 'Silahkan Melengkapi data terlebih dahulu');
                  } else if (foto == null && file == null) {
                    bottomSheetGagal(
                        context: context,
                        title: 'memerlukan file pendukung',
                        subtitle: 'silahkan cantumkan file pendukung');
                  } else {
                    sendRequest(DateFormat('yyyy-MM-dd').format(dateNow),
                        widget.nip, izinCode, _keterangan.text, foto, file);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'AJUKAN IZIN',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
