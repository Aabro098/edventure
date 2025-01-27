import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(pagename: ['Feedback'], selectedIndex: 0),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '"Hey there! \nWe’re always looking to improve, \nand your feedback would mean a lot to us. \nMind sharing your thoughts \non how we’re doing? \nJust let us know!"',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: feedbackController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Provide a feedback...',
                        contentPadding: const EdgeInsets.all(4.0),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppElevatedButton(
                    text: 'Send',
                    color: Colors.green.shade300,
                    onTap: () {
                      feedbackController.clear();
                    },
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
