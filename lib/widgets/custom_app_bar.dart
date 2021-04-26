import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/styles.dart';

AppBar header(context,
    {String networkImage,
    String title,
    String subTitle,
    VoidCallback onPress,
    IconData iconData}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    brightness: Brightness.light,
    elevation: 0.0,
    leading: Icon(
      Icons.view_list_sharp,
      color: primaryColor,
    ),
    title: ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(networkImage),
      ),
      title: Text(title, style: TwitterTextStyle.heading1),
      subtitle: Text(subTitle, style: TwitterTextStyle.heading3),
    ),
    actions: [
      IconButton(onPressed: onPress, icon: Icon(iconData), color: primaryColor)
    ],
  );
}
