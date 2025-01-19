import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/review_services.dart';
import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/Widgets/review_card.dart';
import 'package:edventure/Widgets/user_details.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/review.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/models/user.dart';
import 'package:provider/provider.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userId;
  const ProfileViewScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late Future<User> _userData;
  bool isAddReview = false;
  int _selectedStars = 0;
  final reviewService = ReviewService(baseUrl: uri);
  final TextEditingController _reviewController = TextEditingController();

  void _submitReview(String userId, String senderId) async {
    final review = Review(
      id: userId,
      senderId: senderId,
      description: _reviewController.text.trim(),
      rating: _selectedStars,
    );

    try {
      bool success = await reviewService.submitReview(review);

      if (success) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
        setState(() {
          isAddReview = false;
          _reviewController.clear();
          _selectedStars = 0;
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit review. Please try again.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error submitting review. Please try again later.')),
      );
    }
  }

  late Future<List<Review>> _reviewsFuture;

  void _handleStarTap(int starIndex) {
    setState(() {
      _selectedStars = starIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    _userData = ApiService().fetchUserData(widget.userId);
    _reviewsFuture = reviewService.fetchReviewsByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(pagename: ['Profile'], selectedIndex: 0),
        body: GestureDetector(
          onTap: () {
            setState(() {
              _reviewController.clear();
              _selectedStars = 0;
              isAddReview = false;
            });
          },
          child: FutureBuilder<User>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                final user = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        UserDetails(user: user),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              AppElevatedButton(
                                text: 'Send Message',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualChat(user: user)));
                                },
                                color: Colors.lightGreen.shade600,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                            ],
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
                          child: SingleChildScrollView(
                            child: Text(
                              user.about.isNotEmpty
                                  ? user.about
                                  : 'No description available',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
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
                            const Spacer(),
                            TTextButton(
                              iconData: Icons.edit,
                              onPressed: () {
                                setState(() {
                                  isAddReview = true;
                                });
                              },
                              labelText: 'Add Review',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        isAddReview
                            ? SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _reviewController,
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your review here...',
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
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: List.generate(5, (index) {
                                              return IconButton(
                                                icon: Icon(
                                                  Icons.star,
                                                  color: index < _selectedStars
                                                      ? Colors.yellow
                                                      : Colors.grey,
                                                ),
                                                onPressed: () =>
                                                    _handleStarTap(index + 1),
                                              );
                                            }),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _submitReview(
                                                user.id,
                                                currentUser.id,
                                              );
                                            },
                                            child: const Icon(Icons.check),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : FutureBuilder<List<Review>>(
                                future: _reviewsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No reviews found.'));
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
                                                  reviewId: reviews[index].id,
                                                  senderId:
                                                      reviews[index].senderId,
                                                  description: reviews[index]
                                                      .description,
                                                  rating: reviews[index].rating,
                                                  currentUser: currentUser.id,
                                                  profileUser: user.id),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
