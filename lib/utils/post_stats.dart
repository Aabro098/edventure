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
              Icons.thumb_up , 
              size: 16.0, 
              color: Colors.blue,               
            ),
            const SizedBox(
              width: 7.0,
            ),
            Expanded(
              child: Text('5.0' , style: TextStyle(
                color: Colors.grey[600]
              ),),
            ),
            Text('5 Comments', style: TextStyle(
              color: Colors.grey[600]
            ),),
            const SizedBox(
              width: 4.0,
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
            children: [
              _PostButton(
                icon:Icon(
                  Icons.thumb_up , 
                  color : Colors.grey[600], 
                  size : 20.0
                ), 
                label : 'Like',
                onTap : (){}
              ),
              _PostButton(
                icon:Icon(
                  Icons.comment , 
                  color : Colors.grey[600], 
                  size : 20.0
                ), 
                label : 'Comments',
                onTap : (){}
              ), 
              _PostButton(
                icon:Icon(
                  Icons.share , 
                  color : Colors.grey[600], 
                  size : 25.0
                ), 
                label : 'Share',
                onTap : (){}
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;


  const _PostButton({
    required this.icon, 
    required this.label, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal : 12.0),
            child: SizedBox(
              height: 25.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(label)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}