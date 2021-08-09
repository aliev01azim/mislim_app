class ListviewItemModel {
  int? id;
  late final String name;
  bool? isFavorite;
  late final String title;
  late final String url;
  late final String thumbnailUrl;

  ListviewItemModel(
      {this.id,
      required this.name,
      required this.isFavorite,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  ListviewItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isFavorite = json['isFavorite'];
    name = json['name'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isFavorite'] = isFavorite;
    data['name'] = name;
    data['title'] = title;
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
