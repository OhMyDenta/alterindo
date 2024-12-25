import 'dart:async';

import 'package:alterindo/widgets/Navigation/absensi/absensi_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../component/color.dart';
import 'maps.dart';

class AbsenPages extends StatefulWidget {
  final String nip;
  final String device;
  const AbsenPages({super.key, required this.nip, required this.device});

  @override
  State<AbsenPages> createState() => _AbsenPagesState();
}

class _AbsenPagesState extends State<AbsenPages> {
  String _currentTime = '';
  
  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }
// tidak perlu
  void _updateTime() {
    final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final String formattedTime = DateFormat('HH:mm:ss').format(now);

    setState(() {
      _currentTime = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            textAlign: TextAlign.center,
            'Absensi Karyawan',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.access_time_outlined))
        ],
        toolbarHeight: 70,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.bluewhite,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.access_time_sharp,
                        size: 35,
                      ),
                      const Spacer(),
                      Text(
                        ' $_currentTime',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 22),
                      ),
                      const Spacer(),
                      const SizedBox(
                        height: 35,
                        width: 35,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // GoogleMapWidget(),
              const SizedBox(
                height: 250,
                child: Maps(),
              ),
              const SizedBox(height: 10,),
              AbsensiPages(device: widget.device, nip: widget.nip, ),
            ],
          ),
        ),
      ),
    );
  }
}

