
import 'Region.dart';
import 'Registration.dart';

class UserDetails{
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
  dynamic institutionId;
  String? institutionName;
  String? institutionSportName;
  String? institutionExpired;
  String? institutionRegistrationId;
  String? email;
  String? phone;
  String? iban;
  String? nationality;
  String? birthdayCountry;
  Region? region;
  String? street;
  String? streetNumber;
  String? postalCode;
  String? nbcId;
  String? nbcFuncId;
  String? healthValid;
  String? antidopingValid;
  String? doctorName;
  List<Registration>? registrations;

  UserDetails.fromJson(Map<String, dynamic> json) {

    var list = json['registrations'] as List;
    List<Registration> registrationsList = list.map((i) => Registration.fromJson(i)).toList();

    id = json['id'];
    title = json['title'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    identificationNumber = json['identificationNumber'] ?? '';
    birthday = json['birthday'] ?? '';
    gender = json['gender'] ?? '';
    created = json['created'] ?? '';
    modified = json['modified'] ?? '';
    feeValid = json['feeValid'] ?? '';
    photo = json['photo'] ?? '';
    institutionId = json['institutionId'] ?? '';
    institutionName = json['institutionName'] ?? '';
    institutionSportName = json['institutionSportName'] ?? '';
    institutionExpired = json['institutionExpired'] ?? '';
    institutionRegistrationId = json['institutionRegistrationId'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    iban = json['iban'] ?? '';
    nationality = json['nationality'] ?? '';
    birthdayCountry = json['birthdayCountry'] ?? '';
    region = Region.fromJson(json['region']);
    street = json['street'] ?? '';
    streetNumber = json['streetNumber'] ?? '';
    postalCode = json['postalCode'] ?? '';
    nbcId = json['nbcId'] ?? '';
    nbcFuncId = json['nbcFuncId'] ?? '';
    healthValid = json['healthValid'] ?? '';
    antidopingValid = json['antidopingValid'] ?? '';
    doctorName = json['doctorName'] ?? '';
    registrations = registrationsList;
  }

}

