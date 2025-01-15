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
      notifyListeners();
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
    _user.profileImage = newProfileImage;
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