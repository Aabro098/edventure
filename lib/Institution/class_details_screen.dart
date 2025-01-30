import 'package:edventure/Theme/theme.dart';
import 'package:flutter/material.dart';

class ClassDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> classItem;

  const ClassDetailsScreen({required this.classItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classItem['title'] ?? 'Class Details'),
        backgroundColor: AppTheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Title
            Text(
              classItem['title'] ?? 'Unnamed Class',
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 8),

            // Class Description
            Text(
              classItem['description'] ?? 'No description available',
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            Text(
              'Instructor: ${classItem['instructor_name'] ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            Text(
              'End Date: ${classItem['end_date'] ?? 'No date provided'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Class Thumbnail Image
            classItem['thumbnail_url'] != null
                ? ClipOval(
                    child: Image.network(
                      classItem['thumbnail_url']!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image, size: 100),

            const SizedBox(height: 24),

            // Close Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the detail view
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
