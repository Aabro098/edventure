import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/constants/variable.dart';
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      backgroundImage:
                          NetworkImage('$uri/${user.profileImage}'),
                    )
                  : Icon(
                      Icons.person,
                      size: 160,
                      color: Colors.grey[300],
                    ),
            ),
            const SizedBox(height: 12.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue),
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
                            )),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
            const SizedBox(height: 8.0),
            ProfileList(text: user.email, icons: Icons.email),
            const SizedBox(height: 8.0),
            ProfileList(
                text: user.phone.isNotEmpty ? user.phone : 'Not Available',
                icons: Icons.phone),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.home,
                  size: 28,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.address.isNotEmpty ? user.address : 'Not Available',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ProfileList(
                text: user.education.isNotEmpty
                    ? user.education
                    : 'Not Available',
                icons: Icons.school),
            const SizedBox(height: 20.0),
            Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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

class ProfileList extends StatelessWidget {
  final String text;
  final IconData icons;
  const ProfileList({
    super.key,
    required this.text,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icons,
          size: 28,
          color: Colors.grey.shade400,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
