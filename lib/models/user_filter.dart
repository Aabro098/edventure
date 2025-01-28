class UserFilter {
  String? gender;
  List<String>? skills;

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'skills': skills,
    };
  }
}
