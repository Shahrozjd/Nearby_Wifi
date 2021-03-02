import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//These are you standart pop up dialoges
class Dialogues {
  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red[400],
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}
