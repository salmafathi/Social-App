import 'dart:io';

import 'package:dio/dio.dart';

String exceptionsHandle
({
  required DioError error
})
{
  final String message;
  switch (error.type)
  {

    case  DioErrorType.connectTimeout :
      message = 'server not reachable';
      break;

    case DioErrorType.sendTimeout:
      message = 'send Time out';
      break;
    case DioErrorType.receiveTimeout:
      message = 'server not reachable';
      break;
    case DioErrorType.response:
      message = 'the server response, but with a incorrect status';
      break;
    case DioErrorType.cancel:
      message = 'request is cancelled';
      break;
    case DioErrorType.other:
      error.message.contains('SocketException') ?
      message = 'check your internet connection'
      : message = error.message ;
      break;
  }
  return message ;
}