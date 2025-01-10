import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(
    id: '', 
    name: '', 
    email: '', 
    password: '', 
    phone: '', 
    profileImage: '',
    address: '', 
    bio: '', 
    about : '',
    rating: 0,
    numberRating: 0,  
    education: '',
    type: '', 
    username: '', 
    token: '',
    isVerified : false, 
    review : [], 
    socketId: '',
    teachingAddress: [],
  );

  User get user => _user;
   void setUser(String user){
    _user = User.fromJson(user);
    notifyListeners();
   }

  Future<void> refreshUser(BuildContext context) async {
    try {
      await AuthService().getUserData(context: context);
    } catch (e) {
      throw Exception(e.toString());
    }
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
      about : '',
      rating: 0,
      numberRating: 0,  
      education: '', 
      type: '', 
      username: '', 
      token: '',
      isVerified : false, 
      review : [], 
      socketId: '',
      teachingAddress: [],
    );
    notifyListeners();
  }
}