class Region {
  int? id;
  String? name;
  String? postalCode;

  Region({this.id, this.name, this.postalCode});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    postalCode = json['postalCode'] ?? '';
  }
}