import 'package:eventhive/screens/create_chat_room.dart';
import 'package:eventhive/screens/navigation.dart';
import 'package:eventhive/screens/splash.dart';
import 'package:eventhive/screens/team_registration.dart';
import 'package:eventhive/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:eventhive/screens/login.dart';
import 'package:eventhive/screens/register.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MyRegister());
  runApp(const MaterialApp(
    home: SplashScreen(),
  ));

  Future.delayed(const Duration(seconds: 3), () {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const MyLogin(),
        '/dashboard': (context) => const Navigation(),
        '/_createChatRoom': (context) => CreateChatRoomPage(),
        // '/team_registration': (context) => TeamRegistrationForm(),
      },
    ));
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // TODO: Handle this case.
            final user = AuthService.firebase().currentUser;
            // final provider = AuthService.firebase().provider;
            // print(provider);
            // print(user);
            // print(user?.email);
            if (user != null) {
              print("This is the user: $user");
              return const Navigation();
            } else {
              return const MyLogin();
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
