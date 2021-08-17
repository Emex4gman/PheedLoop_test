import 'package:thread_app/model/api_responce.dart';
import 'package:thread_app/model/comment.dart';
import 'package:thread_app/service/network.dart';

class CommentService {
  static Future<Apiresponce<List<Comment>>> getAllComment() async {
    final result = await NetworkService.getThread();
    if (result.success) {
      List<Comment> comment = List<Comment>.from(result.data.map((e) => Comment.fromJson(e))).toList();
      return Apiresponce(comment, true, result.messsage);
    } else {
      return Apiresponce(<Comment>[], false, result.messsage);
    }
  }

  static Future<Apiresponce<List>> getAllCommentRaw() async {
    final result = await NetworkService.getThread();
    if (result.success) {
      return Apiresponce(result.data, true, result.messsage);
    } else {
      return Apiresponce(<Map<String, dynamic>>[], false, result.messsage);
    }
  }
}
