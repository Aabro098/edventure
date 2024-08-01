
import 'dart:convert';

import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Home%20Screen/home_screen.dart';
import 'package:edventure/constants/error_handling.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        name: name,
        password: password,
        phone: '',
        profileImage: '',
        coverImage: '',
        address: '',
        bio : '',
        rating:0.0,
        education: '',
        status : '',
        type: '',
        username: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account has been created successfully',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email' : email,
          'password' : password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context , listen : false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context, 
            HomeScreen.routeName, 
            (route) => false
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if(token==null){
        prefs.setString('x-auth-token', '');
      }

      var tokenres = await http.post(
        Uri.parse('$uri/isTokenValid'),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token':token!   
        }
      );

      var response = jsonDecode(tokenres.body);

      if(response==true){
        http.Response userRes = await http.get(Uri.parse('$uri/'),
          headers: <String,String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token':token
          }
        );
        var userProvider =Provider.of<UserProvider>(context , listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}
