
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    phone: '',
    profileImage: '',
    address: '',
    bio: '',
    about: '',
    rating: 0,
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

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  Future<void> refreshUser(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token');
      
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse('$uri/'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        setUser(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void addTeachingAddress(String address) {
    _user.teachingAddress.add(address);
    notifyListeners();
  }

  void deleteTeachingAddress(String address) {
    _user.teachingAddress.remove(address);
    notifyListeners();
  }

  void updateProfileImage(String newProfileImage) {
    print("Updating profile image to: $newProfileImage"); // Debug print
    _user.profileImage = newProfileImage;
    print("Updated user profile image: ${_user.profileImage}"); // Verify update
    notifyListeners();
  }
  
  void clearUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      phone: '',
      profileImage: '',
      address: '',
      bio: '',
      about: '',
      rating: 0,
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
    notifyListeners();
  }
}