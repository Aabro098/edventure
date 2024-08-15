import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
import 'package:provider/provider.dart';
import '../../Widgets/stars.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
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
  bool _isEmail = false;
  bool _isBio = false;
  bool _isLoading = false; 

  late TextEditingController aboutController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController educationController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false).user;
    aboutController = TextEditingController(text: user.about);
    nameController = TextEditingController(text: user.name);
    addressController = TextEditingController(text: user.address);
    educationController = TextEditingController(text: user.education);
    phoneController = TextEditingController(text: user.phone);
    emailController = TextEditingController(text: user.email);
    bioController = TextEditingController(text: user.bio);
  }

  Future<void> _handleButtonPress() async {
  if (emailController.text.isEmpty || nameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email and Name cannot be blank')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
    _isLoading ? const CircularProgressIndicator() : null;
  });

  await authService.updateUser(
    context: context,
    email: emailController.text, 
    name: nameController.text,   
    phone: phoneController.text, 
    address: addressController.text, 
    education: educationController.text, 
    bio: bioController.text, 
    about: aboutController.text, 
  );

  setState(() {
    _isLoading = false;
  });
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
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
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
                      child: const CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage(AppImages.profile),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
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
                                    _handleButtonPress();
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
                              ? const Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.blue,
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    user.bio.isNotEmpty
                      ? !_isBio
                        ? GestureDetector(
                          onTap: (){
                            setState(() {
                              _isBio = true;
                            });
                          },
                          child: Text(
                            user.bio,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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
                                  _handleButtonPress();
                                });
                              },
                            ),
                            border: InputBorder.none
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
                      ),
                    const SizedBox(height: 5.0),
                      _isEmail
                          ? TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                setState(() {
                                  _isEmail = false;
                                  _handleButtonPress();
                                });
                              },
                            ),
                            border: InputBorder.none
                          ),
                        )
                        : TTextButton(
                            iconData: Icons.email,
                            onPressed: (){
                              setState(() {
                                _isEmail = !_isEmail; 
                              });
                            },
                            labelText: user.email.isNotEmpty
                                ? user.email
                                : 'Enter Email',
                            color: Colors.blue,
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
                                  _handleButtonPress();
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
                                _handleButtonPress();
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
                                  _handleButtonPress();
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
                        Row(
                          children: [
                            Star(
                              count: (user.ratingNumber != 0)
                                  ? (user.rating / user.ratingNumber)
                                  : 0,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              (user.ratingNumber != 0)
                                  ? (user.rating / user.ratingNumber)
                                      .toStringAsFixed(1)
                                  : '0.0',
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'No of reviews : ${user.ratingNumber}',
                          style: const TextStyle(fontSize: 16.0),
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          ),
                        ),
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Container(
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
                            ),
                            Positioned(
                              bottom: 10, 
                              right: 10, 
                              child: IconButton(
                                icon: _isAbout 
                                ? const Icon(Icons.check , color: Colors.blue)
                                : const Icon(Icons.edit , color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (_isAbout) {
                                      _handleButtonPress();
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
                        user.review.isNotEmpty
                            ? const NotificationCard(review: true)
                            : const Center(
                                child: Text(
                                  'No Reviews available',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
