class ListviewItemShaheModel {
  int? id;
  late final String name;
  late final bool isMale;

  ListviewItemShaheModel({this.id, required this.name, required this.isMale});

  ListviewItemShaheModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isMale = json['isMale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isMale'] = isMale;
    return data;
  }
}
