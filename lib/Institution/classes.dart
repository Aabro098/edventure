// import 'dart:io';

// import 'package:edventure/Institution/subject_details.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../Theme/theme.dart';

// class ClassesScreen extends StatefulWidget {
//   final String mobileNumber;

//   const ClassesScreen({
//     required this.mobileNumber,
//     super.key,
//   });

//   @override
//   ClassesScreenState createState() => ClassesScreenState();
// }

// class ClassesScreenState extends State<ClassesScreen> {
//   Map<String, List<Map<String, dynamic>>> groupedOngoingClasses = {};
//   Map<String, List<Map<String, dynamic>>> groupedCompletedClasses = {};
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // _loadClasses();
//   }

//   // Future<void> _loadClasses() async {
//   //   setState(() => isLoading = true);
//   //   try {
//   //     final ongoingClassData = {
//   //       'mobileNumber': widget.mobileNumber,
//   //       'status': 'ongoing'
//   //     };
//   //     final completedClassData = {
//   //       'mobileNumber': widget.mobileNumber,
//   //       'status': 'completed'
//   //     };

//   //     final ongoingResponse = await _apiService.getClasses(ongoingClassData);
//   //     final completedResponse =
//   //         await _apiService.getClasses(completedClassData);
//   //     debugPrint('ongoingResponse: $ongoingResponse');
//   //     debugPrint('completedResponse: $completedResponse');

//   //     setState(() {
//   //       groupedOngoingClasses = _groupClassesBySubject(ongoingResponse['data']);
//   //       groupedCompletedClasses =
//   //           _groupClassesBySubject(completedResponse['data']);
//   //     });
//   //   } catch (e) {
//   //     if (mounted) {
//   //       _showError('Failed to load classes');
//   //     }
//   //   } finally {
//   //     if (mounted) {
//   //       setState(() => isLoading = false);
//   //     }
//   //   }
//   // }

//   Map<String, List<Map<String, dynamic>>> groupClassesBySubject(
//       List<dynamic> classes) {
//     final grouped = <String, List<Map<String, dynamic>>>{};
//     for (var classItem in classes) {
//       final subject = classItem['subject'] as String? ?? 'Unnamed Subject';
//       if (!grouped.containsKey(subject)) {
//         grouped[subject] = [];
//       }
//       grouped[subject]!.add(Map<String, dynamic>.from(classItem));
//     }
//     return grouped;
//   }

//   void showError(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _navigateToSubject(String subject, List<Map<String, dynamic>> classes) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SubjectDetailsScreen(
//           subject: subject,
//           classes: classes,
//         ),
//       ),
//     );
//   }

//   Widget _buildSubjectTile(String subject, List<Map<String, dynamic>> classes) {
//     final now = DateTime.now();
//     final ongoingCount = classes.where((c) {
//       final endDate = DateTime.tryParse(c['end_date'] ?? '');
//       return endDate != null && endDate.isAfter(now);
//     }).length;

//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () => _navigateToSubject(subject, classes),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.school_outlined,
//                   size: 40,
//                   color: AppTheme.primary,
//                 ),
//                 const SizedBox(height: 12),
//                 Flexible(
//                   child: Text(
//                     subject,
//                     style: AppTheme.headingMedium.copyWith(fontSize: 18),
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildCountChip(
//                   ongoingCount,
//                   'Ongoing',
//                   AppTheme.primary.withOpacity(0.1),
//                   AppTheme.primary,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCountChip(
//       int count, String label, Color bgColor, Color textColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         '$count $label',
//         style: TextStyle(
//           color: textColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent(
//       Map<String, List<Map<String, dynamic>>> groupedClasses) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (groupedClasses.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.school_outlined,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No classes found',
//               style: AppTheme.bodyLarge.copyWith(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
//         childAspectRatio: 0.85,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: groupedClasses.length,
//       itemBuilder: (context, index) {
//         final subject = groupedClasses.keys.elementAt(index);
//         final classes = groupedClasses[subject]!;
//         return _buildSubjectTile(subject, classes);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         title: const Text('Classes'),
//         backgroundColor: AppTheme.primary,
//       ),
//       body: 
//     );
//   }
// }
