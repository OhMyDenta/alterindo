import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../component/color.dart';

class DataHistory extends StatefulWidget {
  final String tanggal;
  final String keterangan;
  final String jamMasuk;
  final String jamPulang;
  final String ketBawah;
  final String shift;
  final String foto;
  final String nama;
  const DataHistory(
      {super.key,
      required this.tanggal,
      required this.keterangan,
      required this.jamMasuk,
      required this.jamPulang,
      required this.ketBawah,
      required this.shift,
      required this.foto,
      required this.nama});

  @override
  State<DataHistory> createState() => _DataHistoryState();
}

class _DataHistoryState extends State<DataHistory> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () => setState(() => selected = !selected),
        child: AnimatedContainer(
          height: selected ? 220 : 40,
          width: double.infinity,
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 0.5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.tanggal,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: widget.keterangan == 'Alpha'
                                ? Colors.red
                                : widget.keterangan == 'Ijin Tidak Masuk'
                                    ? Colors.orange
                                    : widget.keterangan == 'Ijin Sakit'
                                        ? Colors.orange
                                        : widget.keterangan == 'Cuti Reguler'
                                            ? Colors.green
                                            : widget.keterangan == 'Ijin Cuti'
                                                ? Colors.green
                                                : widget.keterangan == 'Libur'
                                                    ? Colors.black
                                                    : Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.5,
                              horizontal: 5,
                            ),
                            child: Text(
                              widget.keterangan,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // menu masuk
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [BoxShadow(color:Colors.black, blurRadius: 0.5),],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: widget.foto.isNotEmpty
                                            ? ClipOval(
                                                child: Image.memory(
                                                  base64Decode(widget.foto),
                                                  fit: BoxFit.cover,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              )
                                            : Text(
                                                widget.nama.isNotEmpty
                                                    ? widget.nama
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Absen Datang', style: TextStyle(color: Colors.black, fontSize: 14)),
                                        Row(
                                          children: [
                                            Text(
                                              widget.jamMasuk,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            
                                             const Padding(
                                               padding: EdgeInsets.symmetric(horizontal:6.0),
                                               child: Text('WIB', style:  TextStyle(color: Colors.grey)),
                                             ),
                                            const Icon( Icons.sync_problem, color: Colors.red),
                                          ],
                                        ),
                                        const Text('Alterindo Software (Pusat)',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              color: AppColors.secondary
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // menu pulang
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [BoxShadow(color:Colors.black, blurRadius: 0.5),],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: widget.foto.isNotEmpty
                                            ? ClipOval(
                                                child: Image.memory(
                                                  base64Decode(widget.foto),
                                                  fit: BoxFit.cover,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              )
                                            : Text(
                                                widget.nama.isNotEmpty
                                                    ? widget.nama
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Absen Pulang' , style: TextStyle(color: Colors.black, fontSize: 14)),
                                        Row(
                                          children: [
                                            Text(
                                              widget.jamPulang, 
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal:6.0),
                                              child: Text('WIB', style: TextStyle(color: Colors.grey)),
                                            ),
                                            const Icon( Icons. check_circle_outline_outlined, color: Colors.green),
                                          ],
                                        ),
                                        const Text(
                                          'Alterindo Software (Pusat)',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.35),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.edit_calendar_sharp,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.ketBawah,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.av_timer,
                                    size: 16,
                                    color: Colors.orange[600],
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Shift : ${widget.shift}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
