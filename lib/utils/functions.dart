import 'dart:math';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions.dart';
import 'fonts.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class CustomSnackbar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static responseSnackbar(BuildContext context , String message ){
    if (message == null) return;
    messengerKey.currentState!.removeCurrentSnackBar();
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        padding: EdgeInsets.all(height(context, 2)),
        elevation: 0.15,
        backgroundColor: CustomColors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: CustomColors.white,
          onPressed: () {
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        content: Text(message ,
          style: TextStyle(
              color: Colors.white,
              fontFamily: CustomFonts.titiliumWeb_Regular,
              fontSize: height(context, 2)
          ),
        )
    );
    messengerKey.currentState?.showSnackBar(snackBar);
  }

}




