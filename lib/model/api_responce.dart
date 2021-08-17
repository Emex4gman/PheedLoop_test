import 'dart:convert';

import 'package:http/http.dart';

class Apiresponce<T> {
  bool success;
  T data;
  String messsage;
  Apiresponce(this.data, this.success, this.messsage);

  static Apiresponce formRespoance(Response response) {
    var responseJson = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return Apiresponce(responseJson, true, "success");
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      return Apiresponce(null, false, "this.messsage");
    } else {
      return Apiresponce(null, false, "this.messsage");
    }
  }
}
