import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/institution_services.dart';
import 'package:edventure/models/classes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrolledClassesScreen extends StatelessWidget {
  final InstitutionService institute = InstitutionService();
  EnrolledClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final List<String> classIds = user.enrolledClasses;

    return Scaffold(
      appBar: AppBar(title: Text("Enrolled Classes")),
      body: FutureBuilder<List<Institution>>(
        future: institute.searchClassesById(classIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No classes found"));
          }

          final institutions = snapshot.data!;

          return ListView.builder(
            itemCount: institutions.length,
            itemBuilder: (context, index) {
              final institution = institutions[index];

              return Card(
                margin: EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text(institution.institutionName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: institution.classOfferings.map((classOffering) {
                    return ListTile(
                      title: Text(classOffering.title),
                      subtitle: Text(
                          "Instructor: ${classOffering.instructor}\nSubject: ${classOffering.subject}"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
