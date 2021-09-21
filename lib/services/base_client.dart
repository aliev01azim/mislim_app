import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'app_exceptions.dart';

class BaseClient {
  static const int timeoutDuration = 10;
  static var client = http.Client();
  static const String baseUrl = 'https://allahakbar.pythonanywhere.com';
  //GET
  Future<dynamic> get(String api) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await client
          .get(uri)
          .timeout(const Duration(seconds: timeoutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('Нет интернет соединения', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('Время истекло', uri.toString());
    }
  }

  // //POST
  // Future<dynamic> post(String api, dynamic payloadObj) async {
  //   var uri = Uri.parse(baseUrl + api);
  //   var payload = json.encode(payloadObj);
  //   try {
  //     var response = await client
  //         .post(uri, body: payload)
  //         .timeout(const Duration(seconds: timeoutDuration));
  //     print(response.statusCode);
  //     throw BadRequestException(
  //         '{"reason":"your message is incorrect", "reason_code":"invalid_message"}',
  //         response.request!.url.toString());
  //     // return _processResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection', uri.toString());
  //   } on TimeoutException {
  //     throw ApiNotRespondingException(
  //         'API not responded in time', uri.toString());
  //   }
  // }

  dynamic _processResponse(http.Response response) {
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return responseJson;
    } else if (response.statusCode == 201) {
      return responseJson;
    } else if (response.statusCode == 400) {
      throw BadRequestException(responseJson, response.request!.url.toString());
    } else if (response.statusCode == 422) {
      throw BadRequestException(responseJson, response.request!.url.toString());
    } else {
      throw FetchDataException(
          'Error occured with code : ${response.statusCode}',
          response.request!.url.toString());
    }
    // доработать?
    // else if (response.statusCode == 403) {
    //   throw UnAuthorizedException(
    //       utf8.decode(response.bodyBytes), response.request!.url.toString());
    // }
  }
}
