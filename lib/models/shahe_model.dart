import 'package:hive_flutter/adapters.dart';
part 'shahe_model.g.dart';

@HiveType(typeId: 1)
class ShaheModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  late final String name;
  @HiveField(2)
  bool? isFavorite;
  ShaheModel({required this.id, required this.name, this.isFavorite = false});

  ShaheModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
