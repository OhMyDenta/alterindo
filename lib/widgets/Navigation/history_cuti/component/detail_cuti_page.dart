import 'dart:convert';
import 'package:alterindo/pages/pdf.dart';
import 'package:flutter/material.dart';
import '../../../../component/color.dart';

class DetailCutiPage extends StatefulWidget {
  final String userOtorisasi;
  final String kodeUnik;
  final String keteranganOtorisasi;
  final String jenis;
  final String tanggalAwal;
  final String tanggalAkhir;
  final String uraian;
  final String foto;
  final String nama;
  final String pdf;
  final int otorisasi;
  const DetailCutiPage({
    super.key,
    required this.userOtorisasi,
    required this.kodeUnik,
    required this.keteranganOtorisasi,
    required this.jenis,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.uraian,
    required this.foto,
    required this.nama,
    required this.pdf,
    required this.otorisasi,
  });

  @override
  State<DetailCutiPage> createState() => _DetailCutiPageState();
}

class _DetailCutiPageState extends State<DetailCutiPage> {
  bool selected = false;
  bool photoS = false;
  bool showPdf = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Detail Pengajuan Cuti',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.otorisasi == 0
                        ? AppColors.threeorange
                        : widget.otorisasi == 1
                            ? AppColors.three
                            : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Center(
                        child: Text(
                          widget.otorisasi == 0
                              ? 'Pending'
                              : widget.otorisasi == 1
                                  ? 'Accepted'
                                  : 'Denied',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 7),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ////////////Column Teks
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kode Otorisasi',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  widget.kodeUnik == ''
                                      ? 'Tidak Ada Kode'
                                      : widget.kodeUnik,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Keterangan Otorisasi',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  widget.keteranganOtorisasi == ''
                                      ? 'Belum Ada Keterangan'
                                      : widget.keteranganOtorisasi,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Permohonan Izin',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 7),
                              ]),
                          // //////////////////////////// Lampanr kumorunokarukari
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.bluewhite,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.nama[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: Text(
                                        widget.nama,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 7),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ////////////Column Teks
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jenis Izin',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: AppColors.secondary, size: 16),
                                  const SizedBox(width: 7),
                                  Text(
                                    widget.jenis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Tanggal Izin',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: AppColors.secondary, size: 16),
                                  const SizedBox(width: 7),
                                  Text(
                                    '${widget.tanggalAwal} s/d ${widget.tanggalAkhir}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Keterangan Izin',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.uraian,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          // //////////////////////////// Lampanr kumorunokarukari

                          const SizedBox(height: 8),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 7),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ////////////Column Teks
                          const Text(
                            'File Pendukung',
                            style: TextStyle(fontSize: 12),
                          ),
                          Column(
                            children: [
                              // PDF
                              Visibility(
                                visible: widget.pdf.isNotEmpty ||
                                    widget.foto.isNotEmpty,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: photoS ? 365 : 50,
                                  width: 315,
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        // Header
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Container(
                                              color: AppColors.secondary,
                                              height: 50,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        showPdf
                                                            ? 'PDF '
                                                            : 'Foto',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Tombol toggle antara PDF dan Foto
                                                if (widget.pdf.isNotEmpty)
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(
                                                          () => showPdf = true);
                                                    },
                                                    icon: Icon(
                                                      Icons.picture_as_pdf,
                                                      color: showPdf
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                if (widget.foto.isNotEmpty)
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() =>
                                                          showPdf = false);
                                                    },
                                                    icon: Icon(
                                                      Icons.image,
                                                      color: !showPdf
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                // Tombol untuk memperbesar atau memperkecil container
                                                IconButton(
                                                  onPressed: () {
                                                    setState(
                                                        () => photoS = !photoS);
                                                  },
                                                  icon: photoS
                                                      ? const Icon(
                                                          Icons
                                                              .keyboard_arrow_up,
                                                          color: Colors.white,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Konten: PDF atau Foto
                                        if (photoS)
                                          SizedBox(
                                            height: 315,
                                            width: 315,
                                            child: showPdf
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return Pdf(
                                                              pdfData:
                                                                  widget.pdf,
                                                              file: null,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            size: 30, color: Colors.red),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Show Pdf File',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Image.memory(
                                                    base64Decode(widget.foto),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // //////////////////////////// Lampanr kumorunokarukari

                          const SizedBox(height: 8),
                        ],
                      )),
                ),
              ),
            ]),
          ),
        ));
  }

}
