class PopularListviewItemModel {
  late final String name;
  late final String url;

  PopularListviewItemModel({required this.name, required this.url});

  PopularListviewItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
