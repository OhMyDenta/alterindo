import 'package:alterindo/component/color.dart';
import 'package:flutter/material.dart';

class DataHistoryCuti extends StatefulWidget {
  final String tanggalAwal;
  final String tanggalAkhir;
  final String jenis;
  final String keterangan;
  final String userOtorisasi;
  final int otorisasi;
  final String keteranganOtorisasi;
  final String kodeUnik;
  final String foto;
  final String dokumen;
  final String nama;
  final Function onDelete;
  final Function onEdite;
  const DataHistoryCuti({
    super.key,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.jenis,
    required this.keterangan,
    required this.userOtorisasi,
    required this.otorisasi,
    required this.keteranganOtorisasi,
    required this.kodeUnik,
    required this.foto,
    required this.dokumen,
    required this.nama,
    required this.onDelete,
    required this.onEdite,
  });

  @override
  State<DataHistoryCuti> createState() => _DataHistoryCutiState();
}

class _DataHistoryCutiState extends State<DataHistoryCuti> {
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Row(children: [
                      const Icon(Icons.calendar_month,
                          color: AppColors.secondary, size: 14),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${widget.tanggalAwal} s/d ${widget.tanggalAkhir}',
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
                        Text(widget.keterangan),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: Row(
                      children: [
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
                                style: const TextStyle(
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
                                widget.onDelete(); 
                              },
                            ),
                          ),
                        if (widget.otorisasi == 0)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.yellow),
                              onPressed: () {
                                widget.onEdite(); 
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
