import 'package:http/http.dart' as http;
import 'package:thread_app/model/api_responce.dart';

const String baseUrl = "https://df0ksgnmih.execute-api.ca-central-1.amazonaws.com/";

class NetworkService {
  static Future<Apiresponce> getThread() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      return Apiresponce.formRespoance(response);
    } catch (e) {
      return Apiresponce(null, false, e.toString());
    }
  }
}
