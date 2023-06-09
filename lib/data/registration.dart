import 'institution.dart';

class Registration {
  String? id;
  String? registrationId;
  String? from;
  String? to;
  String? created;
  String? modified;
  String? status;
  String? comment;
  String? type;
  Institution? institution;

  Registration(
      {this.id,
      this.registrationId,
      this.from,
      this.to,
      this.created,
      this.modified,
      this.status,
      this.comment,
      this.type,
      this.institution});

  Registration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registrationId = json['registrationId'];
    from = json['from'];
    to = json['to'];
    created = json['created'];
    modified = json['modified'];
    status = json['status'];
    comment = json['comment'];
    type = json['type'];
    institution = Institution.fromJson(json['institution']);
  }
}