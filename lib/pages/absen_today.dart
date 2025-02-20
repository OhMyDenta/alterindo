import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../component/color.dart';

class AbsenToday extends StatefulWidget {
  final String nip;
  final VoidCallback onRefresh;
  const AbsenToday({super.key, required this.nip, required this.onRefresh});

  @override
  State<AbsenToday> createState() => _AbsenTodayState();
}

class _AbsenTodayState extends State<AbsenToday> {
  String? _absenTimeMasuk;
  String? _absenTimePulang;

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
    });
    widget.onRefresh();
  } else {
    throw Exception('Failed to load user data');
  }
}


  @override
  void initState() {
    super.initState();
    refreshdata();
  }

  void refreshdata() {
    fetchAbsensData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: 60,
            // width: 60,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: AppColors.three, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.login,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Absend Datang'),
                        Row(
                          children: [
                            Text(
                              _absenTimeMasuk ?? '--:--:--',
                              style: const TextStyle(
                                color: AppColors.three,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text('WIB')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: 60,
            // width: 60,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: AppColors.threeorange, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Absend Pulang'),
                        Row(
                          children: [
                            Text(
                              _absenTimePulang ?? '--:--:--',
                              style: const TextStyle(
                                color: AppColors.three,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text('WIB')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
