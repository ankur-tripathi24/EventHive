import 'package:eventhive/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final name = FirebaseAuth.instance.currentUser!.displayName;
  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001c30),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xff176b87),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage("assets/profile.png"),
            ),
            SizedBox(height: 50.0),
            Text(
              name!,
              style:
                  GoogleFonts.poppins(fontSize: 20.0, color: Color(0xff64ccc5)),
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "E-mail : ",
                  style: TextStyle(fontSize: 16.0, color: Color(0xff64ccc5)),
                ),
                Text(
                  email!,
                  style: TextStyle(fontSize: 16.0, color: Color(0xffdafffb)),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Phone No. : ",
                  style: TextStyle(fontSize: 16.0, color: Color(0xff64ccc5)),
                ),
                Text(
                  "930889899300",
                  style: TextStyle(fontSize: 16.0, color: Color(0xffdafffb)),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Organization : ",
                  style: TextStyle(fontSize: 16.0, color: Color(0xff64ccc5)),
                ),
                Text(
                  "Vishwakarma Institue of Technology",
                  style: TextStyle(fontSize: 16.0, color: Color(0xffdafffb)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
