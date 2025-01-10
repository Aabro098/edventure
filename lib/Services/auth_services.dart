
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:edventure/constants/error_handling.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Auth Screens/Auth/auth_screen.dart';

class AuthService with ChangeNotifier{
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
        address: '',
        bio : '',
        about : '',
        rating:0,
        numberRating: 0,
        education: '',
        type: '',
        username: '',
        token: '',
        isVerified: false, 
        review: [], 
        socketId: '',
        teachingAddress: [],
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
          Navigator.pushNamedAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context, 
            AuthScreen.routeName, 
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


  Future updateUser({
    required BuildContext context,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? education,
    String? bio,
    String? about,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final String url = '$uri/api/update';

    final Map<String, dynamic> data = {
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (education != null) 'education': education,
      if (bio != null) 'bio': bio,
      if (about != null) 'about': about,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(data),
      );
      
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    
      // ignore: use_build_context_synchronously
      Provider.of<UserProvider>(context, listen: false).clearUser();

      Navigator.pushNamedAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<void> uploadProfileImage(BuildContext context) async {
    final String uploadUrl = '$uri/api/updateProfile';
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');

    if (image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No image selected")),
      );
      return;
    }

    try {
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      Dio dio = Dio();
      dio.options.headers["x-auth-token"] = token ?? ''; 

      final response = await dio.put(uploadUrl, data: formData);
      
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile image uploaded successfully!")),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload profile image: ${response.data}")),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
