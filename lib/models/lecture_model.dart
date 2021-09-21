import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:hive/hive.dart';
part 'lecture_model.g.dart';

@HiveType(typeId: 2)
class LectureModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  late final String title;
  @HiveField(2)
  late final String lectureFile;
  @HiveField(3)
  late final String dueTime;
  @HiveField(4)
  late ShaheModel author;
  @HiveField(5)
  late final int categoryId;
  @HiveField(6)
  late final String categoryTitle;
  @HiveField(7)
  bool? isFavorite;
  LectureModel(
      {required this.id,
      required this.categoryId,
      required this.categoryTitle,
      required this.author,
      required this.title,
      this.isFavorite = false,
      required this.lectureFile,
      required this.dueTime});

  LectureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = (json['category'] != null ? json['category']['id'] : null)!;
    categoryTitle =
        (json['category'] != null ? json['category']['title'] : null)!;
    author =
        (json['author'] != null ? ShaheModel.fromJson(json['author']) : null)!;
    title = json['title'];
    lectureFile = json['lecture_file'];
    dueTime = json['due_time'];
    isFavorite = false;
  }
}
