import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../component/color.dart';
  
class Pdf extends StatefulWidget {
  const Pdf({super.key, required this.pdfData,required this.file, });
  final String pdfData;
  final File? file;

  @override
  State<Pdf> createState() => _PdfState();
}
Uint8List base64ToUint8List(String base64String) {
  return base64Decode(base64String);
}

class _PdfState extends State<Pdf> {
   Future<Uint8List?> _getPdfBytes() async {
    if (widget.file != null) {
      return await widget.file!.readAsBytes();
    } else {
      return base64ToUint8List(widget.pdfData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: AppColors.background,
      body: FutureBuilder<Uint8List?>(
        future: _getPdfBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return const Center(child: Text('Error loading PDF'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No PDF data available'));
          } else {
            final pdfBytes = snapshot.data!;
            return PDFView(
              pdfData: pdfBytes,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              onRender: (pages) {
                log('PDF rendered with $pages pages');
              },
              onError: (error) {
                log('Error: $error');
              },
              onPageError: (page, error) {
                log('Page error: $page, $error');
              },
            );
          }
        },
      ),
    
    );
  } 
}