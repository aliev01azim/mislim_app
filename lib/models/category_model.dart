import 'package:hive/hive.dart';
part 'category_model.g.dart';

// @HiveType(typeId: 0)
// class CategoryModel {
//   @HiveField(0)
//   late final int id;
//   @HiveField(1)
//   late final String name;
//   @HiveField(2)
//   late final String url;
//   @HiveField(3)
//   bool? isFavorite;

//   CategoryModel(
//       {required this.name,
//       required this.url,
//       required this.id,
//       this.isFavorite = false});

//   CategoryModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     url = json['url'];
//   }

// }
@HiveType(typeId: 0)
class CategoryModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  late final String title;
  @HiveField(2)
  late final String image;
  @HiveField(3)
  bool? isFavorite;
  @HiveField(4)
  DateTime? dateTime;
  // late List<Lectures>? lectures;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
    this.isFavorite = false,
    this.dateTime,
    // this.lectures,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // if (json['lectures'] != null) {
    //   lectures = <Lectures>[];
    //   json['lectures'].forEach((v) {
    //     lectures!.add(Lectures.fromJson(v));
    //   });
    // }
    image = json['image'];
    title = json['title'];
    isFavorite = false;
    dateTime = DateTime.now();
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
