import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhive/screens/create_chat_room.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> chatRooms = []; // Create a list to store chat room names

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('participants', arrayContains: userEmail)
          .get();

      final chatRoomNames = querySnapshot.docs.map((doc) {
        return doc['name'] as String;
      }).toList();

      setState(() {
        chatRooms = chatRoomNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatRooms[index]),
                  onTap: () {
                    // Navigate to the selected chat room
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateChatRoomPage(),
                  ),
                );
              },
              child: Text('Create Chat Room'),
            ),
          ),
        ],
      ),
    );
  }
}
