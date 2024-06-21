import 'package:flutter/material.dart';
import 'package:flutter_form/model/user.dart';

class UserInfoPage extends StatelessWidget {
  User? userInfo;
  UserInfoPage({this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Info'),
      ),
      body: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${userInfo!.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('${userInfo!.story}'),
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              trailing: Text('${userInfo!.country}'),
            ),
            ListTile(
              title: Text(
                '${userInfo!.phone}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.phone, color: Colors.black),
            ),
            if (userInfo!.email != null && userInfo!.email!.isNotEmpty)
              ListTile(
                title: Text(
                  '${userInfo!.email}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: Icon(
                  Icons.mail,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
