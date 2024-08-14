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
    about : '',
    rating: 0,
    ratingNumber: 0,  
    education: '', 
    status: '', 
    type: '', 
    username: '', 
    token: '',
    isVerified : false, 
    posts: [],
    review : []
  );

  User get user => _user;
   void setUser(String user){
    _user = User.fromJson(user);
    notifyListeners();
   }
}