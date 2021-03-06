import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_proto_app_b2b/models/auth_dto.dart';
import 'package:restaurant_proto_app_b2b/services/db_service.dart';

class AccountNotifier extends ChangeNotifier {

  AuthDTO _authDTO = new AuthDTO(tableNum: 1);
  DbService dbService = DbService();

  Future<bool> get isLogedIn async{

    bool _isLogedIn = false;

    _checkLocalStorage();

    if(this._authDTO.authToken != null && !JwtDecoder.isExpired(this._authDTO.authToken!)){
      _isLogedIn = true;
    }else{
      updateAuthToken(null, needNotify: false);
    }

    return _isLogedIn;
  }

  void doNotify(){
    notifyListeners();
  }

  void _checkLocalStorage(){
    this._authDTO.authToken = dbService.getAuthToken();
  }

  void updateAuthToken(String? newToken, {bool needNotify = true}){
    dbService.setAuthToken(newToken);
    if (needNotify) notifyListeners();
  }
}
