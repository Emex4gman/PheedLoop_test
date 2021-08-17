class Comment {
  String id;
  String text;
  String? parentId;
  String date;
  Comment(this.id, this.text, this.date, this.parentId);
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(json['id'], json['text'], json['date'], json['parentId']);
  }
}
