import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Services/review_services.dart';
import 'package:edventure/Widgets/review_card.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/review.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
import 'package:provider/provider.dart';
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
  bool _isName = false;
  bool _isAddress = false;
  bool _isEducation = false;
  bool _isBio = false;
  late bool isAvailable;

  final reviewService = ReviewService(baseUrl: uri);

  late TextEditingController aboutController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController educationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false).user;
    _reviewsFuture = reviewService.fetchReviewsByUserId(user.id);
    aboutController = TextEditingController(text: user.about);
    nameController = TextEditingController(text: user.name);
    addressController = TextEditingController(text: user.address);
    educationController = TextEditingController(text: user.education);
    phoneController = TextEditingController(text : user.phone);
    emailController = TextEditingController(text: user.email);
    bioController = TextEditingController(text: user.bio);
    isAvailable = user.isAvailable;
  }

  Future<void> updateEmail() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (emailController.text.isNotEmpty && emailController.text != user.email) {
      await authService.updateUser(context: context, email: emailController.text);
    }
  }

  Future<void> updateName() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (nameController.text.isNotEmpty && nameController.text != user.name) {
      await authService.updateUser(context: context, name: nameController.text);
    }
  }

  Future<void> updatePhone() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (phoneController.text != user.phone) {
      await authService.updateUser(context: context, phone: phoneController.text);
    }
  }

  Future<void> updateAddress() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (addressController.text != user.address) {
      await authService.updateUser(context: context, address: addressController.text);
    }
  }

  Future<void> updateEducation() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (educationController.text != user.education) {
      await authService.updateUser(context: context, education: educationController.text);
    }
  }

  Future<void> updateBio() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (bioController.text != user.bio) {
      await authService.updateUser(context: context, bio: bioController.text);
    }
  }

  Future<void> updateAbout() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (aboutController.text != user.about) {
      await authService.updateUser(context: context, about: aboutController.text);
    }
  }

  Future<void> toggleAvailability() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String token = userProvider.user.token;
      User updatedUser = await ApiService().toggleAvailability(token);
      setState(() {
        isAvailable = updatedUser.isAvailable;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Could not change the state!!!');
    }
  }

  @override
  void dispose() {
    aboutController.dispose();
    nameController.dispose();
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

  void _changeName() {
    setState(() {
      _isName = !_isName;
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
            _isName = false;
          });
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
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
                                radius: 120,
                                backgroundImage: AssetImage(user.profileImage),
                              )
                              : const Icon(Icons.person, size: 240),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: AppElevatedButton(
                                text: user.isAvailable? 'Rest' : 'Active', 
                                onTap: toggleAvailability,
                                color: user.isAvailable ?  Colors.red.shade400 : Colors.green.shade400,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _isName
                            ? Expanded(
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.check),
                                    onPressed: () {
                                      setState(() {
                                        _isName = false;
                                        updateName();
                                      });
                                    },
                                  ),
                                  border: InputBorder.none
                                ),
                              ),
                            )
                            : GestureDetector(
                                onDoubleTap: _changeName,
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8.0),
                            Text(
                              '(${user.username})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
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
                                          onTap: (){},
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
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.background),
                          fit: BoxFit.contain,
                        ),
                      ),
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
                          height: 90,
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
                              ? TextField(
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
                                    contentPadding: EdgeInsets.only(
                                        top: 4.0, left: 8.0),
                                  ),
                                )
                              : Text(
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Recent Reviews',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<Review>>(
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
                            itemCount: (reviews.length / 2).ceil(),
                            itemBuilder: (context, index) {
                              final startIndex = index * 2;
                              final secondReview = (startIndex + 1 < reviews.length) ? reviews[startIndex + 1] : null;
                              return Row(
                                children: [
                                  Expanded(
                                    child: ReviewCard(
                                      senderId: reviews[startIndex].senderId,
                                      description: reviews[startIndex].description,
                                      rating: reviews[startIndex].rating,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  secondReview != null
                                      ? Expanded(
                                          child: ReviewCard(
                                            senderId: secondReview.senderId,
                                            description: secondReview.description,
                                            rating: secondReview.rating,
                                          ),
                                        )
                                      : Expanded(child: Container()),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
