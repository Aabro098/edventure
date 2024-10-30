import 'dart:async';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Services/review_services.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/review.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/review_card.dart';
import '../../Widgets/stars.dart';

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
  bool _isAddress = false;
  bool _isEducation = false;
  bool _isBio = false;
  late bool isAvailable;
  bool isLoading = false;
  final reviewService = ReviewService(baseUrl: uri);

  late TextEditingController aboutController;
  late TextEditingController addressController;
  late TextEditingController educationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    final user = Provider.of<UserProvider>(context, listen: false).user;
    _reviewsFuture = reviewService.fetchReviewsByUserId(user.id);
    aboutController = TextEditingController(text: user.about);
    addressController = TextEditingController(text: user.address);
    educationController = TextEditingController(text: user.education);
    phoneController = TextEditingController(text : user.phone);
    emailController = TextEditingController(text: user.email);
    bioController = TextEditingController(text: user.bio);
    isAvailable = user.isAvailable;
  }

  Future<void> updatePhone() async {
    try {
      await authService.updateUser(
        context: context,
        phone: phoneController.text,
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> updateAddress() async {
    try {
      await authService.updateUser(
        context: context,
        address: addressController.text,
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }


  Future<void> updateEducation() async {
    try {
      await authService.updateUser(
        context: context,
        education: educationController.text,
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }


  Future<void> updateBio() async {
    try {
      await authService.updateUser(
        context: context,
        bio: bioController.text,
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }


  Future<void> updateAbout() async {
    try {
      await authService.updateUser(
        context: context,
        about: aboutController.text,
      );
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }


  Future<void> toggleAvailability() async {
    if (isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String token = userProvider.user.token;
      
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final User updatedUser = await ApiService().toggleAvailability(token).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (updatedUser.token.isEmpty) {
        final userMap = updatedUser.toMap();
        userMap['token'] = token;  
        final String userJson = User.fromMap(userMap).toJson();
        userProvider.setUser(userJson);
      } else {
        final String userJson = updatedUser.toJson();
        userProvider.setUser(userJson);
      }
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        
        String errorMessage = 'Could not change the state!';
        if (e is TimeoutException) {
          errorMessage = 'Request timed out. Please try again.';
        } else if (e.toString().contains('Authentication failed')) {
          errorMessage = 'Session expired. Please login again.';
        } else if (e.toString().contains('No authentication token')) {
          errorMessage = 'Please login to continue.';
        } else if (e.toString().contains('Failed to toggle availability')) {
          errorMessage = 'Server error. Please try again later.';
        }
        
        showSnackBar(context, errorMessage);
      }
    }
  }


  @override
  void dispose() {
    aboutController.dispose();
    addressController.dispose();
    educationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bioController.dispose();
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

  void _changeAddress() {
    setState(() {
      _isAddress = !_isAddress;
    });
  }

  void updateProfileImage() async {
    try {
      await AuthService().uploadProfileImage(context);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload profile image: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          setState(() {
            _isBio = false;
            _isPhone = false;
            _isAbout = false;
            _isAddress = false;
            _isEducation = false;
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:  user.isAvailable 
                                  ? Colors.green.shade300 : Colors.red.shade200,
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
                              backgroundImage: NetworkImage('$uri${user.profileImage}'),
                            )
                            : const Icon(Icons.person, size: 100),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: ClipOval(
                              child: GestureDetector(
                                onTap: updateProfileImage,
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
                      const SizedBox(width: 10,),
                      Expanded(
                        child: AppElevatedButton(
                          text: isLoading 
                            ? 'Updating...' 
                            : user.isAvailable 
                              ? 'Rest' 
                              : 'Active',
                          onTap: isLoading ? null : toggleAvailability,
                          color: user.isAvailable 
                            ? Colors.red.shade400 
                            : Colors.green.shade400,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
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
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              
                                            },
                                            child: const Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.blue,
                                                ),
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text('Verified',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue
                                      ),
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
                                      onTap: (){
                                    
                                      },
                                      child: const Text('Verify Now',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ),
                      ],
                    ),
                  ),
                ),
                !_isBio
                  ? user.bio.isNotEmpty
                    ? GestureDetector(
                      onTap: (){
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
                      onPressed: (){
                        setState(() {
                          _isBio = true;
                        });
                      }, 
                      labelText: 'Edit Bio'
                    )
                  : TextField(
                      controller: bioController,
                      decoration: InputDecoration(
                        hintText: 'Write what describes you the most...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                        ),
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
                        border: InputBorder.none
                      ),
                    ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12,0,0,0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.email,
                          style:  const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        const SizedBox(width: 8),
                        !user.isEmailVerified 
                        ? GestureDetector(
                            onTap: (){},
                            child: const Text('Verify Email',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue
                              ),
                            ),
                          )
                          : const SizedBox.shrink()
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
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        prefixIcon: const Icon(Icons.phone_android_outlined),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              _isPhone = false;
                              updatePhone();
                            });
                          },
                        ),
                        border: InputBorder.none
                      ),
                    )
                      : TTextButton(
                          iconData: Icons.phone_android,
                          onPressed: _changePhone,
                          labelText: user.phone.isNotEmpty
                              ? user.phone
                              : 'Enter Phone',
                        ),
                  const SizedBox(height: 5.0),
                  _isAddress
                    ? TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),
                      prefixIcon: const Icon(Icons.home),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            _isAddress = false;
                            updateAddress();
                          });
                        },
                      ),
                      border: InputBorder.none
                    ),
                  )
                  : TTextButton(
                      iconData: Icons.home,
                      onPressed: _changeAddress,
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
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
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
                        border: InputBorder.none
                      ),
                    )
                  : TTextButton(
                      iconData: Icons.school,
                      onPressed: _changeEducation,
                      labelText: user.education.isNotEmpty
                          ? user.education
                          : 'Enter Education',
                    ),
                const SizedBox(height: 5.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Star(
                            count: (user.numberRating != 0)
                                ? ((user.rating / user.numberRating).round())
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
                const Padding(
                  padding: EdgeInsets.all(5.0),
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
                                contentPadding: EdgeInsets.only(top: 4.0, left: 8.0),
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
                            : const Icon(Icons.edit, color: Colors.black),
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
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }
}


