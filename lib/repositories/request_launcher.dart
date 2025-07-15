import 'dart:core';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../repositories/api_status.dart';
import '../utils/enums.dart';

class MakeRequest{
  static Future<dynamic> getRequest ( BuildContext context, StartRequest startRequest) async {
    try{
      var url = Uri.parse(startRequest.url);
      http.Response response = await http.get( url );
      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 ) {
        return Success(code: response.statusCode, message : "Successfully fetched" ,response: responseBody );
      }
      if(response.statusCode >= 300 && response.statusCode < 500 ){
        return Failure(code: response.statusCode, errorResponse: "Failed to fetch Items");
      }
      return Failure(code: response.statusCode, errorResponse: "Sorry server error");
    }on HttpException {
      return Failure(code: StatusCode.noInternet.code, errorResponse: 'No Internet');
    } on SocketException {
      return Failure(code: StatusCode.noInternet.code, errorResponse: 'No Internet connection');
    }on FormatException{
      return Failure(code: StatusCode.invalidFormat.code, errorResponse: 'Please wait a moment...');
    }catch(err){
      return Failure(code: StatusCode.unknownError.code, errorResponse: '$err');
    }
  }
}

class StartRequest{
  String url;
  Map<String , dynamic >? body;
  String? header;

  StartRequest({
    required this.url,
    this.body = null,
    this.header = null
});
}
class Signature1{
  final String sha1hex;
  final String sha256hex;
  final String sha1base64;
  final String sha256base64;
  Signature1({ required this.sha1hex ,required this.sha256hex , required this.sha1base64 , required this.sha256base64} );
}