import 'package:flutter/material.dart';

import 'custom_text.dart';

class TopBuyerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('images/profile.jpg'),
      ),
      title: Text('Vedant'),
      subtitle: Text('1, order'),
      trailing: CustomText(
        text: '\$ 10000',
        color: Colors.green.shade800,
        weight: FontWeight.bold,
      ),
    );
  }
}
