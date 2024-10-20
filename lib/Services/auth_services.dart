
import 'dart:convert';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:edventure/constants/error_handling.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future signUpUser({
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
        about : '',
        rating:0,
        numberRating: 0,
        education: '',
        status : '',
        type: '',
        username: '',
        token: '',
        isVerified: false, 
        posts: [],
        review: [], 
        isEmailVerified: false, 
        isAvailable: false, 
        notification: [],
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
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account has been created successfully',
          );
        },
      );
    } catch (e) {
      Future.delayed(Duration.zero, () {
        // ignore: use_build_context_synchronously
        showSnackBar(context, e.toString());
      });
    }
  }

  Future signInUser({
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
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context , listen : false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context, 
            NavScreen.routeName, 
            (route) => false
          );
        },
      );
    } catch (e) {
      Future.delayed(Duration.zero, () {
        // ignore: use_build_context_synchronously
        showSnackBar(context, e.toString());
      });
    }
  }

  Future<void> getUserData({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
        token = ''; 
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/isTokenValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        // ignore: use_build_context_synchronously
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
        Future.microtask(() {
          // ignore: use_build_context_synchronously
          showSnackBar(context, e.toString());
      });
    }
    }

  Future<void> updateUser({
    required BuildContext context,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? education,
    String? bio,
    String? about,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        throw Exception('No token found');
      }

      Map<String, dynamic> updates = {};

      if (email != null) updates['email'] = email;
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (education != null) updates['education'] = education;
      if (bio != null) updates['bio'] = bio;
      if (about != null) updates['about'] = about;

      http.Response res = await http.put(
        Uri.parse('$uri/api/update'),
        body: jsonEncode(updates),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'User information updated successfully',
          );
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
        },
      );
    } catch (e) {
      Future.delayed(Duration.zero, () {
        // ignore: use_build_context_synchronously
        showSnackBar(context, e.toString());
      });
    }
  }
}
