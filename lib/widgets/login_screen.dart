// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../component/color.dart';
import 'home_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();

  bool status = false;
  late String nip;
  late String device;

  Future<void> setPref(String nipInput, String deviceInput) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', true);
    await prefs.setString('nip', nipInput);
    await prefs.setString('device', deviceInput);
  }

  Future<void> getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      status = prefs.getBool('status') ?? false;
      nip = prefs.getString('nip') ?? '';
      device = prefs.getString('device') ?? '';
    });
  }

//
  void login(String nipInput, String kodeAktivasi) async {
    final response = await http.post(
      Uri.parse(
        'https://www.mydeveloper.pro/hris/api.php?action=login',
      ),
      headers: {'Authorization': 'Bearer 123456789'},
      body: jsonEncode({
        'NIP': nipInput,
        'KodeAktivasi': kodeAktivasi,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String dataNip = data['NIP'] ?? '';
      String dataDevice = data['Device'] ?? '';
      setPref(dataNip, dataDevice);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePages(
              nip: dataNip,
              device: dataDevice,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        _NextPage();
      }
      return null;
    }
  }

  // ////////////

  void _NextPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 300,
            width: 90,
            child: Column(
              children: [
                const Spacer(),
                Image.asset('assets/ci_off-close.png'),
                const Spacer(),
                const Text('Error',
                    style: TextStyle(color: AppColors.secondary, fontSize: 20)),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('masukan NIP atau Kode dengan benar'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: AppColors.secondary),
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (status) {
      return HomePages(nip: nip, device: device);
    } else {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/Open Page.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Sizedbox = appbar image
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/Group 63.png'),
                  const SizedBox(height: 4),
                  const Text(
                    "IT-Consultant-Inovatif Software Solution",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 450,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome Back!',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            )),
                        const SizedBox(height: 15),
                        const Text(
                            'Silahkan masukkan NIP, Password, dan Kode Aktivasi Anda.'),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nipController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1.5),
                            ),
                            hintText: "NIP",
                            hintStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _kodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1.5),
                            ),
                            hintText: "Kode Aktivasi",
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                login(
                                    _nipController.text, _kodeController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 92, vertical: 24),
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
