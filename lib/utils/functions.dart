import 'dart:math';
import 'package:flutter/material.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class CustomSnackbar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar({ required String title , required String message , required bool isSuccess }) {
    if (message == null) return;
    messengerKey.currentState!.removeCurrentSnackBar();

  }

}

class BasicFunctions{
  static shortenText( { required String text, required int limit}) {
    return text.length <= limit ? text : "${text.substring(0, limit)}...";
  }
  static particularText( { required String text, required bool isFirst}) {
    return isFirst ? text.substring(0, 1) : text.substring(1, text.length);
  }
}
int generateRandomNumber(int max) {
Random random = Random();
return random.nextInt(max);
}



