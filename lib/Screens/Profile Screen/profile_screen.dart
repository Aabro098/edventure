import 'dart:async';
import 'dart:convert';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Address/address_selection.dart';
import 'package:edventure/Screens/verification_screen.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Services/review_services.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/Widgets/options_bottomsheet.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/review.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../utils/review_card.dart';
import '../../Widgets/stars.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();
  bool _isAbout = false;
  bool _isPhone = false;
  bool _isEducation = false;
  bool _isBio = false;
  bool _isDropdownVisible = false;
  late bool isAvailable;
  bool isLoading = false;
  final reviewService = ReviewService(baseUrl: uri);
  final ApiService apiService = ApiService();
  final List<String> _genderOptions = ['Male', 'Female', 'Others', 'None'];

  late TextEditingController aboutController;
  late TextEditingController educationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late Future<List<Review>> _reviewsFuture;
  late TextEditingController skillController;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    final user = Provider.of<UserProvider>(context, listen: false).user;
    _reviewsFuture = reviewService.fetchReviewsByUserId(user.id);
    aboutController = TextEditingController(text: user.about);
    educationController = TextEditingController(text: user.education);
    phoneController = TextEditingController(text: user.phone);
    emailController = TextEditingController(text: user.email);
    bioController = TextEditingController(text: user.bio);
    skillController = TextEditingController();
    _selectedGender = user.gender;
  }

  Future<void> updatePhone() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      await authService.updateUser(
        context: context,
        phone: phoneController.text,
      );

      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .refreshUser(context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateEducation() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService.updateUser(
        context: context,
        education: educationController.text,
      );

      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .refreshUser(context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> updateBio() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService.updateUser(
        context: context,
        bio: bioController.text,
      );

      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .refreshUser(context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> updateAbout() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService.updateUser(
        context: context,
        about: aboutController.text,
      );

      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .refreshUser(context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    aboutController.dispose();
    educationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bioController.dispose();
    skillController.dispose();
    super.dispose();
  }

  void _changePhone() {
    setState(() {
      _isPhone = !_isPhone;
    });
  }

  void _changeEducation() {
    setState(() {
      _isEducation = !_isEducation;
    });
  }

  void updateProfileImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (mounted) {
        await AuthService().uploadProfileImage(context);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload profile image: $e")),
        );
      }
    }
  }

  Future<void> deleteProfileImage() async {
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentContext = context;

    try {
      setState(() {
        isLoading = true;
      });

      await AuthService().deleteProfileImage(currentContext);

      if (!mounted) return;

      // ignore: use_build_context_synchronously
      await Provider.of<UserProvider>(currentContext, listen: false)
          // ignore: use_build_context_synchronously
          .refreshUser(currentContext);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Profile image deleted successfully")),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Failed to delete profile image: $e")),
      );
    }
  }

  Future<void> updateGender(String userId, String newGender) async {
    final response = await http.put(
      Uri.parse('$uri/updateGender'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gender': newGender,
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Profile Updated Successfully!!!');
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Profile Could not be Updated !!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    Future<void> addSkill(String skill) async {
      await apiService.addSkill(user.id, skill, context).then((_) {
        setState(() {
          user.skills.add(skill);
        });
      }).catchError((error) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, error.toString());
      });
    }

    Future<void> deleteSkill(String skill) async {
      apiService.deleteSkill(user.id, skill, context).then((_) {
        setState(() {
          user.skills.remove(skill);
        });
      }).catchError((error) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, error.toString());
      });
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isBio = false;
            _isPhone = false;
            _isAbout = false;
            _isEducation = false;
            _isDropdownVisible = false;
          });
        },
        child: SingleChildScrollView(
          child: Consumer<UserProvider>(builder: (context, userProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green.shade300,
                                  width: 5.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: user.profileImage.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          '$uri/${user.profileImage}'),
                                    )
                                  : Icon(Bootstrap.person,
                                      size: 160, color: Colors.grey[300]),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: ClipOval(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) =>
                                            bottomSheet(context));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Center(
                            child: user.isVerified
                                ? Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.blue,
                                          ),
                                          const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 4.0),
                                      const Text(
                                        'Verified',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.blue),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.grey,
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 4.0),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerificationScreen()),
                                          );
                                        },
                                        child: const Text(
                                          'Verify Now',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.blue),
                                        ),
                                      )
                                    ],
                                  )),
                      ],
                    ),
                  ),
                  !_isBio
                      ? user.bio.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isBio = true;
                                });
                              },
                              child: Text(
                                user.bio,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : TTextButton(
                              iconData: Icons.person,
                              onPressed: () {
                                setState(() {
                                  _isBio = true;
                                });
                              },
                              labelText: 'Edit Bio')
                      : TextField(
                          controller: bioController,
                          decoration: InputDecoration(
                              hintText: 'What describes you the most...',
                              hintStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                              prefixIcon: const Icon(Icons.person_outlined),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    _isBio = false;
                                    updateBio();
                                  });
                                },
                              ),
                              border: InputBorder.none),
                        ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          AntDesign.mail_outline,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.email,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  _isPhone
                      ? TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              hintText: 'Phone',
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                              prefixIcon: const Icon(Bootstrap.phone),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    _isPhone = false;
                                    updatePhone();
                                  });
                                },
                              ),
                              border: InputBorder.none),
                        )
                      : TTextButton(
                          iconData: Icons.phone_android,
                          onPressed: _changePhone,
                          labelText: user.phone.isNotEmpty
                              ? user.phone
                              : 'Enter Phone',
                        ),
                  const SizedBox(height: 5.0),
                  TTextButton(
                    iconData: Icons.home,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressSelection()),
                      );
                    },
                    labelText: user.address.isNotEmpty
                        ? user.address
                        : 'Enter Address',
                  ),
                  const SizedBox(height: 5.0),
                  _isEducation
                      ? TextField(
                          controller: educationController,
                          decoration: InputDecoration(
                              hintText: 'Education',
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                              prefixIcon: const Icon(Icons.school),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    _isEducation = false;
                                    updateEducation();
                                  });
                                },
                              ),
                              border: InputBorder.none),
                        )
                      : TTextButton(
                          iconData: Icons.school,
                          onPressed: _changeEducation,
                          labelText: user.education.isNotEmpty
                              ? user.education
                              : 'Enter Education',
                        ),
                  const SizedBox(height: 5.0),
                  TTextButton(
                      iconData: Bootstrap.person,
                      onPressed: () {
                        setState(() {
                          _isDropdownVisible = !_isDropdownVisible;
                        });
                      },
                      labelText: user.gender),
                  if (_isDropdownVisible)
                    Center(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        onChanged: (String? newGender) {
                          setState(() {
                            if (newGender != null) {
                              _selectedGender = newGender;
                              _isDropdownVisible = false;
                              userProvider.updateGender(newGender);
                              updateGender(userProvider.user.id, newGender);
                            }
                          });
                        },
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Star(
                                count: (user.numberRating != 0)
                                    ? ((user.rating / user.numberRating)
                                        .round())
                                    : 0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                (user.numberRating != 0)
                                    ? (user.rating / user.numberRating)
                                        .toStringAsFixed(1)
                                    : '0.0',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No of reviews : ${user.numberRating}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: _isAbout
                            ? SingleChildScrollView(
                                child: TextField(
                                  controller: aboutController,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      overflow: TextOverflow.clip,
                                    ),
                                    border: InputBorder.none,
                                    alignLabelWithHint: true,
                                    contentPadding:
                                        EdgeInsets.only(top: 4.0, left: 8.0),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Text(
                                  user.about.isNotEmpty
                                      ? user.about
                                      : 'Enter your short description',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: _isAbout
                              ? const Icon(Icons.check, color: Colors.blue)
                              : const Icon(AntDesign.edit_outline,
                                  color: Colors.black38),
                          onPressed: () {
                            setState(() {
                              if (_isAbout) {
                                updateAbout();
                              }
                              _isAbout = !_isAbout;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  user.isVerified
                      ? const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              'Skills',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  user.isVerified && user.skills.isNotEmpty
                      ? Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            runSpacing: 6,
                            children: user.skills
                                .map((skill) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: TAppColor.getRandomColor()),
                                      ),
                                      child: IntrinsicWidth(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              skill,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              color: Colors.red,
                                              iconSize: 16,
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () =>
                                                  deleteSkill(skill),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: 8.0),
                  user.isVerified
                      ? Center(
                          child: TTextButton(
                              iconData: AntDesign.edit_outline,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Add New Skill'),
                                        content: AppForm(
                                            controller: skillController,
                                            hintText: 'e.g. Science'),
                                        actions: [
                                          AppElevatedButton(
                                            text: 'Add Skill',
                                            color: Colors.green.shade300,
                                            onTap: () {
                                              final newskill =
                                                  skillController.text;

                                              if (newskill.isNotEmpty) {
                                                addSkill(newskill);
                                                skillController.clear();
                                                Navigator.pop(context);
                                              } else {
                                                showSnackBar(context,
                                                    'Skill cannot be empty');
                                                skillController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              labelText: 'Add Skills',
                              color: Colors.blue.shade400),
                        )
                      : SizedBox.shrink(),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  Center(
                    child: Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  FutureBuilder<List<Review>>(
                    future: _reviewsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No reviews found.'));
                      }
                      final reviews = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ReviewCard(
                                    senderId: reviews[index].senderId,
                                    description: reviews[index].description,
                                    rating: reviews[index].rating,
                                    currentUser: user.id,
                                    reviewId: reviews[index].id,
                                    profileUser: user.id,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: OptionsBottom(
        options: [
          {
            "text": "Update Profile Image",
            "icon": Icons.image,
            "onTap": updateProfileImage,
          },
          {
            "text": "Remove Profile Image",
            "icon": Icons.delete,
            "color": Colors.red,
            "onTap": deleteProfileImage,
          },
        ],
        option: 'Options',
      ),
    );
  }
}
