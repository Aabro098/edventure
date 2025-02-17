import 'package:edventure/Services/review_services.dart';
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
    skills: [],
    contacts: [],
    gender: '',
    progress: false,
    enrolledClasses: [],
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

      if (token == null || token.isEmpty) {
        throw Exception('No auth token found');
      }

      final response = await http.get(
        Uri.parse('$uri/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        setUser(response.body);
      } else {
        throw Exception('Failed to refresh user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to refresh user: $e');
    }
  }

  void addTeachingAddress(String address) {
    if (address.isNotEmpty && !_user.teachingAddress.contains(address)) {
      _user.teachingAddress.add(address);
      notifyListeners();
    }
  }

  void addEnrollClass(String classId, BuildContext context) {
    _user.enrolledClasses.add(classId);
    notifyListeners();
  }

  void deleteTeachingAddress(String address) {
    _user.teachingAddress.remove(address);
    notifyListeners();
  }

  void setProgress(bool progress) {
    _user.progress = progress;
    notifyListeners();
  }

  void updateUserAddress(String newAddress) {
    _user.address = newAddress;
    notifyListeners();
  }

  void updateGender(String newGender) {
    _user.gender = newGender;
    notifyListeners();
  }

  Future<void> updateProfileImageAndRefresh(
      String newProfileImage, BuildContext context) async {
    _user.profileImage = newProfileImage;
    notifyListeners();

    await refreshUser(context);
    notifyListeners();
  }

  Future<void> deleteReview({
    required String reviewId,
    required String senderId,
    required int rating,
    required String profileUser,
  }) async {
    try {
      final response = await ReviewService(baseUrl: uri).deleteReview(
        reviewId: reviewId,
        userId: profileUser,
        senderId: senderId,
        rating: rating,
      );

      if (response['success']) {
        _user.review.remove(reviewId);
        _user.rating -= rating;
        _user.numberRating -= 1;
        notifyListeners();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception('Error deleting review: $e');
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
        about: '',
        rating: 0,
        numberRating: 0,
        education: '',
        type: '',
        username: '',
        token: '',
        isVerified: false,
        progress: false,
        review: [],
        socketId: '',
        teachingAddress: [],
        skills: [],
        contacts: [],
        enrolledClasses: [],
        gender: '');
    notifyListeners();
  }
}
