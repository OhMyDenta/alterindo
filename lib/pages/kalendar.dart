import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../component/color.dart';

class Kalendar extends StatefulWidget {
  final String nip;
  const Kalendar({super.key, required this.nip});

  @override
  _KalendarState createState() => _KalendarState();
}

class _KalendarState extends State<Kalendar> {
  late Future<Map<String, int>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchAbsensiData();
  }

  Future<Map<String, int>> fetchAbsensiData() async {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);
    final Map<String, int> absensiData = {};

    for (int i = 0; i < 6; i++) {
      final currentMonth =
          DateTime(sixMonthsAgo.year, sixMonthsAgo.month + i, 1);
      final formattedMonth = DateFormat('yyyy-MM').format(currentMonth);

      final response = await http.get(
        Uri.parse(
            'https://www.mydeveloper.pro/hris/api.php?action=data_absen_history&id=${widget.nip}&TanggalAwal=$formattedMonth-01&TanggalAkhir=$formattedMonth-31'),
        headers: {'Authorization': 'Bearer 123456789'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        absensiData[DateFormat('MMM').format(currentMonth)] = data.length;
      } else {
        absensiData[DateFormat('MMM').format(currentMonth)] = 0;
      }
    }
    return absensiData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/avatars/Vector (1).png',
                  height: 18, width: 18),
              const SizedBox(width: 10),
              const Text('Performa Kehadiran',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, int>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Gagal mengambil data absensi.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data absensi.'));
              }

              final absensiData = snapshot.data!;
              return SizedBox(
                height: 350,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 31,
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 30) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 30) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final months = absensiData.keys.toList();
                            if (value < 1 || value > months.length) {
                              return  const Text('');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(months[value.toInt() - 1],
                                  style: const TextStyle(fontSize: 12)),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: _generateBarGroups(absensiData),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(Map<String, int> absensiData) {
    final List<BarChartGroupData> barGroups = [];
    int index = 1;
    absensiData.forEach((month, count) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade800],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 18,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
      index++;
    });
    return barGroups;
  }
}
