import 'Region.dart';
import 'user.dart';

class InstitutionDetails{
  int? id;
  String? name;
  String? sportName;
  String? created;
  String? modified;
  String? ico;
  String? dic;
  String? icdph;
  Region? region;
  String? form;
  String? email;
  String? web;
  String? ibanState;
  String? iban;
  String? membershipPrice;
  String? keyDelegate;
  String? voteOrgans;
  String? voteRules;
  String? street;
  String? streetNumber;
  String? postalCode;
  List<User>? members;

    InstitutionDetails({
    this.id,
    this.name,
    this.sportName,
    this.created,
    this.modified,
    this.ico,
    this.dic,
    this.icdph,
    this.region,
    this.form,
    this.email,
    this.web,
    this.ibanState,
    this.iban,
    this.membershipPrice,
    this.keyDelegate,
    this.voteOrgans,
    this.voteRules,
    this.street,
    this.streetNumber,
    this.postalCode,
    this.members
  });

   factory InstitutionDetails.fromJson(Map<String, dynamic> json) {
    var list = json['members'] as List;
    List<User> membersList = list.map((i) => User.fromJson(i)).toList();
    
    return InstitutionDetails(
      id: json['id'],
      name: json['name'],
      sportName: json['sportName'],
      created: json['created'],
      modified: json['modified'],
      ico: json['ico'],
      dic: json['dic'],
      icdph: json['icdph'],
      region: Region.fromJson(json['region']),
      form: json['form'],
      email: json['email'],
      web: json['web'],
      ibanState: json['ibanState'],
      iban: json['iban'],
      membershipPrice: json['membershipPrice'],
      keyDelegate: json['keyDelegate'],
      voteOrgans: json['voteOrgans'],
      voteRules: json['voteRules'],
      street: json['street'],
      streetNumber: json['streetNumber'],
      postalCode: json['postalCode'],
      members: membersList,
    );
  }
}




