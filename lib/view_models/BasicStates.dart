import 'package:flutter/material.dart';
import 'package:jellyjelly/models/Jelly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/api_status.dart';
import '../repositories/request_launcher.dart';
import '../utils/functions.dart';

class BasicState extends ChangeNotifier{
  int currentIndex = 0;
  List<Jelly>? jellies;

  setCurrentIndex(int index ){
    currentIndex = index;
    notifyListeners();
  }

  Future<void> fetchJellies(BuildContext context) async {
    var response = await MakeRequest.getRequest( context , StartRequest(url: "https://yemzybhin.github.io/jsonholder/jelly.json"));
    if(response is Success){
      var details = AllJellies.fromJson(response.response).jellies;
      jellies = details;
    }
    if(response is Failure ){
      CustomSnackbar.responseSnackbar(context, response.errorResponse);
    }
    notifyListeners();
  }

  Future<bool> getFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? result = pref.getBool('firstTime');
    if (result != null) {
      return result;
    }
    return true;
  }

  Future<void> updateFirstTime(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('firstTime', value);
    notifyListeners();
  }
}