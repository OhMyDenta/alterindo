// ignore_for_file: no_wildcard_variable_uses

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

ApiFunction get C => ApiFunction._();

class ApiFunction {
  factory ApiFunction() => ApiFunction._();
  ApiFunction._();
  GetStorage box = GetStorage();

  Future<Response<dynamic>> post({
    required String url,
    required String data,
    String? token,
  }) async {
    try {
      final response = await Dio().post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint('(Response) status code: ${response.statusCode}');
      debugPrint('(Response) body: ${response.data}');
      debugPrint('(Resoinse) type: ${response.data.runtimeType.toString()}');
      return response;
    } catch (_) {
      throw Exception('(Dio) Error post: $_');
    }
  }

  Future<Response<dynamic>> get({
    required String url,
    String? token,
  }) async {
    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (_) {
      throw Exception('(Dio) Error get: $_');
    }
  }

  String format(DateTime date) {
    final DateFormat result = DateFormat('dd MMM yyyy');
    return result.format(date);
  }

  String dataFoto() {
    return box.read('foto');
  }
}
