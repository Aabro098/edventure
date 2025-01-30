import 'package:dotted_border/dotted_border.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/providers/user_provider.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  final User user;
  const VerificationScreen({super.key, required this.user});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  final List<File?> _documents = [null, null, null];
  final List<String> _labels = [
    "Citizenship/Liscence/Id Card Front",
    "Citizenship/Liscence/Id Card Back",
    "Highest Degree Certificate"
  ];

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _documents[index] = File(pickedFile.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _documents[index] = null;
    });
  }

  Future<void> _uploadDocuments() async {
    bool allUploaded = _documents.every((doc) => doc != null);
    if (!allUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload all documents.")),
      );
      return;
    }

    var uri = Uri.parse('https://your-api-endpoint.com/verify');
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = widget.user.name;
    request.fields['email'] = widget.user.email;
    request.fields['phone'] = widget.user.phone;
    request.fields['address'] = widget.user.address;

    for (var i = 0; i < _documents.length; i++) {
      if (_documents[i] != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'document_$i',
            _documents[i]!.path,
          ),
        );
      }
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setProgress(true);

        // ignore: use_build_context_synchronously
        showSnackBar(context, "Documents uploaded successfully!");
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Failed to upload documents. Please try again.");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Documents"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...List.generate(_labels.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _pickImage(index),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _documents[index] == null
                                  ? DottedBorder(
                                      color: Colors.grey,
                                      strokeWidth: 2,
                                      dashPattern: [6, 3],
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _documents[index]!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            if (_documents[index] != null)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              AppElevatedButton(
                text: 'Submit',
                color: Colors.green.shade400,
                onTap: _uploadDocuments,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
