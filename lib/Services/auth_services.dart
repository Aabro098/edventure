import 'package:edventure/constants/error_handling.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import '../constants/variable.dart';


class AuthService{
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try{
      User user = User(
        id: '', 
        email: email, 
        name: name, 
        password: password, 
        address: '', 
        phone: '', 
        bio: '', 
        status: '', 
        rating: 0.0, 
        profileImage: '', 
        coverImage: '', 
        education: '', 
        type: '', 
        username: '', 
        token: '',
      );
      http.Response res = await http.post(
        Uri.parse("$uri/api/signup") , 
        body: user.toJson(),
        headers: <String ,String>{
          'Content-Type' : 'application/json; charset=UTF-8'
        }
      );
      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: (){
          showSnackBar(
            context,
            'Account has been created successfully'
          );
        }
      );
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}