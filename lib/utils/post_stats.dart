import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';

class PostStats extends StatelessWidget {
  const PostStats({    
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.remove_red_eye_outlined , 
              size: 16.0, 
              color: Colors.grey,               
            ),
            const SizedBox(
              width: 7.0,
            ),
            Expanded(
              child: Text('5 Views' , style: TextStyle(
                color: Colors.grey[600]
              ),),
            ),
            Text('5 Shares' , style: TextStyle(
              color: Colors.grey[600]
            ),),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TTextButton(
                iconData: Icons.message_outlined, 
                onPressed: (){}, 
                labelText: 'Message', 
                color: Colors.green.shade500
              ),
              TTextButton(
                iconData: Icons.save_outlined, 
                onPressed: (){}, 
                labelText: 'Save', 
                color: Colors.grey.shade500
              ), 
              TTextButton(
                iconData: Icons.share_outlined, 
                onPressed: (){}, 
                labelText: 'Share', 
                color: Colors.blue.shade500
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
