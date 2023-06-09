class Institution {
  int? id;
  String? name;
  String? sportName;
  String? created;
  String? modified;

  Institution({this.id, this.name, this.sportName, this.created, this.modified});

  Institution.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    sportName = json['sportName'];
    created = json['created'];
    modified = json['modified'];
  }
}