import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../component/color.dart';
import 'absen_today.dart';

class TimePages extends StatefulWidget {
  final String nip;
  const TimePages({super.key, required this.nip});

  @override
  State<TimePages> createState() => _TimePagesState();
}

class _TimePagesState extends State<TimePages> {
  String _currentTime = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();

    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final String formattedTime = DateFormat('HH:mm:ss').format(now);
    final String formattedDate = DateFormat('d MMM yyyy').format(now);

    setState(() {
      _currentTime = formattedTime;
      _currentDate = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ///////////////////////////waktu
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      'Today : $_currentDate',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      ' $_currentTime WIB',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              // //////////////////////////////////////////////// Time
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AbsenToday(nip: widget.nip,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}