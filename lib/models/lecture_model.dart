class LectureModel {
  late final int id;
  late final int category;
  late final int author;
  // late final String name;
  bool? isFavorite;
  late final String title;
  // аудио
  late final String lecture_file;

  LectureModel(
      {required this.id,
      required this.category,
      required this.author,
      // required this.name,
      this.isFavorite = false,
      required this.title,
      required this.lecture_file});

  LectureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    author = json['author'];
    // name = json['name'];
    // isFavorite
    title = json['title'];
    lecture_file = json['lecture_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['name'] = name;
    data['title'] = title;
    data['audioUrl'] = lecture_file;
    return data;
  }
}
