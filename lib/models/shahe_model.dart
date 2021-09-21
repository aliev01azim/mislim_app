import 'package:hive_flutter/adapters.dart';
part 'shahe_model.g.dart';

// @HiveType(typeId: 1)
// class ShaheModel {
//   @HiveField(0)
//   late final int id;
//   @HiveField(1)
//   late final String name;
//   @HiveField(2)
//   bool? isFavorite;
//   ShaheModel({required this.id, required this.name, this.isFavorite = false});

//   ShaheModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     return data;
//   }
// }
@HiveType(typeId: 1)
class ShaheModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  late final String title;
  @HiveField(2)
  bool? isFavorite;
  // late List<Lectures>? lectures;

  ShaheModel({
    required this.id,
    required this.title,
    this.isFavorite = false,
    // this.lectures,
  });

  ShaheModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // if (json['lectures'] != null) {
    //   lectures = <Lectures>[];
    //   json['lectures'].forEach((v) {
    //     lectures!.add(Lectures.fromJson(v));
    //   });
    // }
    title = json['name'];
    isFavorite = false;
  }
}

// class Lectures {
//   late final int id;
//   late Category category;
//   late Author author;
//   late final String title;
//   late final String lectureFile;
//   late final String dueTime;

//   Lectures(
//       {required this.id,
//       required this.category,
//       required this.author,
//       required this.title,
//       required this.lectureFile,
//       required this.dueTime});

//   Lectures.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     category = (json['category'] != null
//         ? Category.fromJson(json['category'])
//         : null)!;
//     author = (json['author'] != null ? Author.fromJson(json['author']) : null)!;
//     title = json['title'];
//     lectureFile = json['lecture_file'];
//     dueTime = json['due_time'];
//   }
// }

// class Category {
//   late final int id;
//   late final String url;
//   late final String title;

//   Category({required this.id, required this.url, required this.title});

//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     url = json['url'];
//     title = json['title'];
//   }
// }

// class Author {
//   late final int id;
//   late final String name;

//   Author({required this.id, required this.name});

//   Author.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }
// }
