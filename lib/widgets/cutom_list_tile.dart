import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/styles.dart';

class CustomListTile extends StatelessWidget {
  String title;
  String description;
  VoidCallback onPress;
  CustomListTile({this.title, this.description, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(radius: 24),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TwitterTextStyle.heading5),
                IconButton(
                    onPressed: onPress,
                    icon: Icon(Icons.more_horiz, color: grey))
              ],
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  description,
                  style: TwitterTextStyle.heading6,
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.grey[800],
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
