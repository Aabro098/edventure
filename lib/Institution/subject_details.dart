import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:edventure/Services/institution_services.dart';
import 'package:edventure/models/classes_model.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:edventure/Theme/theme.dart';
import 'package:edventure/Widgets/app_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  ClassScreenState createState() => ClassScreenState();
}

class ClassScreenState extends State<ClassScreen> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'subject';
  late Future<List<Institution>> _searchResults = Future.value([]);

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text('Subject'),
                value: 'subject',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text('Institution'),
                value: 'institution',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchClasses() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      showSnackBar(context, "Please enter a search query");
      return;
    }

    setState(() => _isLoading = true);

    try {
      _searchResults =
          InstitutionService().searchClasses(_selectedFilter, query);

      setState(() {});
    } catch (error) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void enrollInClass(
      BuildContext context, ClassOffering classItem, String userId) {
    final classId = classItem.id;

    InstitutionService.enrollUserInClass(userId, classId, context)
        .then((response) {
      if (response.success) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Enrollment Successful!!!');
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Enrollment Failed!!!');
      }
    }).catchError((error) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: CustomAppBar(pagename: ['Search'], selectedIndex: 0),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search classes...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => _searchClasses(),
                        ),
                      ),
                      onSubmitted: (_) => _searchClasses(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<Institution>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (_isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return _buildInstitutionList(snapshot.data!, user);
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstitutionList(List<Institution> institutions, User user) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: institutions.length,
      itemBuilder: (context, index) {
        final institution = institutions[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    institution.institutionName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...institution.classOfferings.map((classItem) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () =>
                          _showClassDetailsDialog(context, classItem, user),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: classItem.thumbnail.isNotEmpty
                                  ? Image.network(
                                      classItem.thumbnail,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child:
                                              const Icon(Icons.image, size: 30),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 30),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    classItem.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    classItem.description,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Instructor: ${classItem.instructor}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '\$${classItem.price}',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClassDetailsDialog(
      BuildContext context, ClassOffering classItem, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(classItem.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(classItem.description),
                const SizedBox(height: 8),
                DetailsRow(
                  text: 'Duration :',
                  exactText: classItem.duration,
                  icon: Bootstrap.calendar,
                ),
                const SizedBox(height: 6),
                DetailsRow(
                    text: 'Schedule :',
                    exactText: classItem.schedule,
                    icon: Bootstrap.clock),
                const SizedBox(height: 6),
                DetailsRow(
                    text: 'Available Slots :',
                    exactText: classItem.availableSlots.toString(),
                    icon: Bootstrap.person),
                const SizedBox(height: 6),
                DetailsRow(
                    text: 'Enrolled Students :',
                    exactText: classItem.studentsEnrolled.toString(),
                    icon: Bootstrap.person_fill),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                enrollInClass(context, classItem, user.id);
                Navigator.pop(context);
              },
              child: const Text("Enroll Now"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class DetailsRow extends StatelessWidget {
  final String text;
  final String exactText;
  final IconData icon;
  const DetailsRow({
    super.key,
    required this.text,
    required this.exactText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 4,
      runSpacing: 4,
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        Text(
          exactText,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
