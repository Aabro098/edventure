import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    print(user.numberRating);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: user.isAvailable 
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
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
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
                      ? const Row(
                        children: [
                          Stack(
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
                            ),
                            SizedBox(width: 4.0),
                            Text('Verified',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue
                              ),
                            )
                        ],
                      ) 
                        : const Row(
                          children: [
                            Stack(
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
                          ],
                        )
                ),
              ],
            ),
            const SizedBox(width: 10,),
            Align(
              alignment: Alignment.center,
              child: user.bio.isNotEmpty
                ? Container(
                  alignment: Alignment.centerLeft,
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
                : const SizedBox.shrink(),
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
                ],
              ),
            ),  
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(12,0,0,0),
              child: Row(
                children: [
                  const Icon(
                    Icons.phone_android,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.phone,
                    style:  const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(12,0,0,0),
              child: Row(
                children: [
                  const Icon(
                    Icons.home,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.address,
                    style:  const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(12,0,0,0),
              child: Row(
                children: [
                  const Icon(
                    Icons.school,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.education,
                    style:  const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(
                  'No of reviews : ${user.numberRating}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
