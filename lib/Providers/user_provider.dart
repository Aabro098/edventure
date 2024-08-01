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
    coverImage: '', 
    address: '', 
    bio: '', 
    rating: 0.0, 
    education: '', 
    status: '', 
    type: '', 
    username: '', 
    token: ''
  );

  User get user => _user;
   void setUser(String user){
    _user = User.fromJson(user);
    notifyListeners();
   }
}