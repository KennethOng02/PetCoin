import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.message),
              title: message(index, context),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 5),
    );
  }

  message(int index, BuildContext context) {
    double textSize = 14;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: 'Message Description',
        style: TextStyle(
          fontSize: textSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
