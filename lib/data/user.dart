class User {
  int? id;
  String? title;
  String? firstName;
  String? lastName;
  String? identificationNumber;
  String? birthday;
  String? gender;
  String? created;
  String? modified;
  String? feeValid;
  String? photo;
  String? institutionId;
  String? institutionName;
  String? institutionSportName;
  String? institutionExpired;
  String? institutionRegistrationId;

  User({
    this.id,
    this.title,
    this.firstName,
    this.lastName,
    this.identificationNumber,
    this.birthday,
    this.gender,
    this.created,
    this.modified,
    this.feeValid,
    this.photo,
    this.institutionId,
    this.institutionName,
    this.institutionSportName,
    this.institutionExpired,
    this.institutionRegistrationId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      title: json['title']?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      identificationNumber: json['identificationNumber'] ?? '',
      birthday: json['birthday'] ?? '' ,
      gender: json['gender'] ?? '',
      created: json['created'] ?? '',
      modified: json['modified'] ?? '',
      feeValid: json['feeValid'] ?? '',
      photo: json['photo'] ?? '',
      institutionId: (json['institutionId'].toString()),
      institutionName: json['institutionName'] ?? '',
      institutionSportName: json['institutionSportName'] ?? '',
      institutionExpired: json['institutionExpired'] ?? '' ,
      institutionRegistrationId: json['institutionRegistrationId'] ?? '',
    );
  }
}
