import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatroom.dart';

class CreateChatRoomPage extends StatefulWidget {
  @override
  _CreateChatRoomPageState createState() => _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final List<String> participants = [];

  void _addParticipant() {
    setState(() {
      participants.add(emailController.text);
      emailController.clear();
    });
  }

  void _createChatRoom() {
    // Generate a unique room code
    String roomCode = generateRoomCode();

    // Create the chat room with the name and participants
    ChatRoom chatRoom =
        ChatRoom(name: roomNameController.text, participants: participants);

    // Save the chat room to Firebase Firestore
    FirebaseFirestore.instance.collection('chat_rooms').doc(roomCode).set({
      'name': chatRoom.name,
      'participants': chatRoom.participants,
    }).then((value) {
      // Successfully created the chat room
      // You can navigate to the chat room using the room code and team name
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(
            teamId: roomCode,
            teamName: roomNameController.text,
          ),
        ),
      );
    }).catchError((error) {
      // Handle any errors that occur during chat room creation
      print('Error creating chat room: $error');
    });
  }

  String generateRoomCode() {
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final codeLength = 6; // Adjust the length as needed

    String code = '';
    for (int i = 0; i < codeLength; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chat Room'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: roomNameController,
              decoration: InputDecoration(labelText: 'Chat Room Name'),
            ),
            SizedBox(height: 20),
            Text('Participants:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: participants.length,
              itemBuilder: (context, index) {
                return Text(participants[index]);
              },
            ),
            TextField(
              controller: emailController,
              decoration:
                  InputDecoration(labelText: 'Add Participant by Email'),
            ),
            ElevatedButton(
              onPressed: _addParticipant,
              child: Text('Add Participant'),
            ),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: Text('Create Chat Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoom {
  final String name;
  final List<String> participants;

  ChatRoom({required this.name, required this.participants});
}
