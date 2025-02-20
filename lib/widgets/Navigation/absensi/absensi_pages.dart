// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class AbsensiPages extends StatefulWidget {
  final String nip;
  final String device;
  const AbsensiPages({super.key, required this.nip, required this.device,});

  @override
  State<AbsensiPages> createState() => _AbsensiPagesState();
}

class _AbsensiPagesState extends State<AbsensiPages> {
  String _currentDate = '';
  String? _absenTimeMasuk;
  String? _absenTimePulang;
  String? _lateDuration;

  bool visi = false;

  String jamMasuk = '';
  String jamPulang = '';
  String terlambat = '';
  String toleransi = '';
  String shift = '';
  late Timer timer;
  late tz.TZDateTime currentTime;
  late double height;

  double latCor = 1.2878;
  double longCor = 103.8666;

  @override
  void initState() {
    super.initState();
    _updateDate();
    fetchShiftData();
    fetchAbsensData();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDate());
  }
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  void scanQR() async {
    try {
      String barcodeScanRes;
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        false,
        ScanMode.QR,
      );
      if (mounted) {
        if (barcodeScanRes != '-1') {
          log(barcodeScanRes);
          addData(barcodeScanRes);
        }
      }
    } on PlatformException {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Function Device Not Ready'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> addData(String data) async {
  final date = DateFormat('yyyy-MM-dd').format(currentTime);
  final time = DateFormat('HH:mm').format(currentTime);
  final body = {
    "Token": data,
    "Kode": widget.nip,
    "Tanggal": date,
    "JamMasuk": time,
    "Device": widget.device,
  };
  final uri =
      Uri.parse('https://www.mydeveloper.pro/hris/api.php?action=insert_absen');
  final response = await http.post(
    uri,
    body: jsonEncode(body),
    headers: {'Authorization': 'Bearer 123456789'},
  );

  final responseData = jsonDecode(response.body);
  if (responseData.containsKey('message')) {
    final message = responseData['message'];
    if (message == 'Absen Berhasil') {
      setState(() {
        _absenTimeMasuk = time; 
      });
      _showAbsenSuccessPopup(time, shift);
    } else if (message == 'Absen Pulang Berhasil') {
      setState(() {
        _absenTimePulang = time; 
      });
      _showAbsenSuccessPopup(time, shift);
    } else if (message == 'Anda Sudah Absen') {
      _showAlreadyAbsenPopup(message);
    } else {
      _showOutOfTimePopup();
    }
    fetchAbsensData();
  } else {
    log(response.body);
  }
}

  void fetchAbsensData() async {
  final response = await http.get(
    Uri.parse(
        'https://www.mydeveloper.pro/hris/api.php?action=data_absen&id=${widget.nip}'),
    headers: {'Authorization': 'Bearer 123456789'},
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    setState(() {
      _absenTimeMasuk = json['JamMasuk'] ?? '--:--:--';
      _absenTimePulang = json['JamPulang'] ?? '--:--:--';
      _lateDuration = json['Terlambat'] ?? '';

    });
  } else {
    throw Exception('Failed to load user data');
  }
}

  fetchShiftData() async {
    final response = await http.get(
      Uri.parse(
          'https://www.mydeveloper.pro/hris/api.php?action=data_shift&id=${widget.nip}'),
      headers: {'Authorization': 'Bearer 123456789'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      setState(() {
        shift = json['Shift'];
      });
    } else {
      throw Exception('Failed to load shift');
    }
  }

// ///////////////
  void _updateDate() {
  final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));
  currentTime = tz.TZDateTime.now(tz.UTC).add(const Duration(hours: 7));
  final String formattedDate = DateFormat('d-M-yyyy').format(now);
  setState(() {
    _currentDate = formattedDate;
  });
}


// /////////////////////////
  void _showAbsenSuccessPopup(String absenTime, String shift) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Absensi Berhasil"),
            ],
          ),
          content: Text("$shift berhasil pada $absenTime"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyAbsenPopup(String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text("Sudah Absen"),
            ],
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showOutOfTimePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("Waktu Tidak Valid"),
            ],
          ),
          content: const Text(
              "Absensi hanya dapat dilakukan pada waktu yang ditentukan."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAbsenError(String message) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text('Absensi Sedang Error'),
              ],
            ),
            content: const Text('coba lagi nanti'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
            child: Row(
              children: [
                Icon(Icons.work, color: Colors.blue, size: 18),
                SizedBox(width: 10),
                Text(
                  "Shift Pagi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.login, color: Colors.blue),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _absenTimeMasuk ?? "--:--:--",
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _lateDuration ??
                        'Normal Absensi QR tanggal : $_currentDate',
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.logout, color: Colors.orange),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _absenTimePulang ?? "--:--:--",
                    style: const TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Normal Absensi QR tanggal : $_currentDate',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: scanQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "ABSEN",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
