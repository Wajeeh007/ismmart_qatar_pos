class DropDownModel {
  String? id;
  String? name;

  DropDownModel({
    this.id,
    this.name,
  });

  DropDownModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}