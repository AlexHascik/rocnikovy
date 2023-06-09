import 'package:flutter_rocnikovy/data/institution.dart';
import 'package:flutter_rocnikovy/data/institution_details.dart';
import 'package:flutter_rocnikovy/data/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/user_details.dart';

class API{

  //routes
   String loginPath = "https://old.kolky.sk/user/login";
   String institutionsList = "https://regapi.kolky.sk/institution/list";
   String institutionDetail = "https://regapi.kolky.sk/institution/detail";
   String registrationsList = "https://regapi.kolky.sk/registration/list";
   String personLookup = "https://regapi.kolky.sk/person/list_v2";
   String personDetail = "https://regapi.kolky.sk/person/detail";
   String validateHash = "https://regapi.kolky.sk/user/validateHash";
   String xAppAccesToken = "SK-81a92pceq-a123-9283-a5f7-0192qwp1mn44";

  

  //headers 
  Map<String, String> headers = {
    "Content-Type": 'application/json' , //application/json; charset=utf-8
    "X-App-AccessToken": "SK-81a92pceq-a123-9283-a5f7-0192qwp1mn44"
  };

  Future<http.Response> sendRequest(String path, Map<String, String> header, Map<String, String> body) async{
    var response = await http.post(Uri.parse(path), headers: header, body: jsonEncode(body));
    print(jsonDecode(response.body));
    return response;
  }

  Future<List<User>> getUsers() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   
    var response = await http.post(Uri.parse(personLookup),headers: <String, String>{
          'X-Registrations-AccessToken': prefs.getString('accessToken')!
          },
          body: jsonEncode(<String, String>{
            "birthdayFrom": "1890-01-01",
            "birthdayTo": "2030-01-01"
          }));
    final body = json.decode(response.body);
    return parseUsers(body);

  }
List<User> parseUsers(dynamic responseBody) {
    if (responseBody is String) {
        final parsed = json.decode(responseBody);
        final users = parsed["persons"] as List;
        return users.map((e) => User.fromJson(e)).toList();
    }
    final users = responseBody["persons"] as List;
    return users.map((e) => User.fromJson(e)).toList();
}

 Future<InstitutionDetails> getInstitutionDetails(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(institutionDetail),
        headers: <String, String>{
          'X-Registrations-AccessToken': prefs.getString('accessToken')!,
          'Content-Type': 'application/json'
          },
          body: jsonEncode(<String, int>{
            "id": id
          }
    ));
      final body = json.decode(response.body);
      return InstitutionDetails.fromJson(body['institution']);
  }

   Future<UserDetails> getUserDetails(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(personDetail),
        headers: <String, String>{
          'X-Registrations-AccessToken': prefs.getString('accessToken')!,
          'Content-Type': 'application/json'

          },
          body: jsonEncode(<String, int>{
            
            "id": id
          }
    ));
      final body = json.decode(response.body);
      return UserDetails.fromJson(body['person']);
  }
  bool receivedError(var response){   
    return response['errorCode'] != null;
  }

  void handleError(var response){
    print('Not sure yet');
          
  }

}    