class Note {
  String? id;
  String? userId;
  String? title;
  String? content;
  DateTime? dateAdded;

  Note({ this.id, this.userId, this.title, this.content, this.dateAdded});

  factory Note.fromMap(Map<String, dynamic> map){
    return Note(
      id: map["id"],
      userId: map["userId"],
      title: map["title"],
      content: map["content"],
      dateAdded: DateTime.tryParse(map["dateAdded"]),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "userId": userId,
      "title": title,
      "content": content,
      "dateAdded": dateAdded!.toIso8601String()
    };
  }
}