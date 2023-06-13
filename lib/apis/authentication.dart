import 'package:flutter_rocnikovy/apis/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class AuthAPI extends API{

  Future<bool> login(String email, String password)async{
    Map<String, String> body = {
      'email': email,
      'password': password
    };
    final userInfo = await sendRequest(loginPath, headers, body);
    
    if(jsonDecode(userInfo.body)['errorCode'] != null){
      return false;
    }
    return userValidateHash(userInfo, email);
  }


  Future<bool> userValidateHash(var userInfo, String email) async{
    var accessToken = (jsonDecode(userInfo.body))['accessToken'];
    Map<String, String> body = {
      'email': email,
      'token': accessToken
    };
    final response = await sendRequest(validateHash, super.headers, body);
    if(receivedError(jsonDecode(response.body))){
      return false;
    }
    var decodedResponse = jsonDecode(response.body);
    saveDataToSharedPreferences(decodedResponse);
    return true;

  }

  void saveDataToSharedPreferences(var userInfo) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('accessToken', userInfo['user']['accessToken']);
    await sharedPreferences.setInt('userId', userInfo['user']['id']);
    await sharedPreferences.setInt('institutionId', userInfo['user']['institution']['id']);
    await sharedPreferences.setString('username', userInfo['user']['name']);
    await sharedPreferences.setString('institutionName', userInfo['user']['institution']['name']);
    await sharedPreferences.setString('institutionSportName', userInfo['user']['institution']['sportName']);
  }
  
  
  
}