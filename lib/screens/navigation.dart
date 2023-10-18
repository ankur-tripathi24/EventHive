import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhive/screens/dashboard.dart';
import 'package:eventhive/screens/history.dart';
import 'package:eventhive/screens/profile.dart';
import 'package:eventhive/screens/search.dart';
import 'package:eventhive/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const Center(
          child: DashBoard(),
        );
      case 1:
        return const Center(
          child: Search(),
        );
      case 2:
        return const Center(
          child: History(),
        );
      case 3:
        return Center(
          child: ProfilePage(),
        );
      default:
        return const Center(
          child: Text('Home'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        backgroundColor: const Color(0xFF176B87),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
