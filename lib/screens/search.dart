import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhive/screens/chatroom.dart';
import 'package:eventhive/screens/group_chats/group_chat_screen.dart';
import 'package:eventhive/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  late Map<String, dynamic>? userMap = null;
  bool isLoading = false;
  TextEditingController _search = TextEditingController();
  AuthService _authService = AuthService.firebase();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await _firestore
        .collection('users')
        .doc(_authService.currentUser!.id)
        .update({
      'status': status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .where("email", isEqualTo: _search.text)
        .get()
        .then(((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
        _search.text = "";
      });
      print(userMap);
    }));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Color(0xFF176B87),
      ),
      body: isLoading
          ? Center(
              child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator()))
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                ElevatedButton(
                    onPressed: onSearch,
                    child: Text("Search"),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF176B87),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        tileColor: Colors.grey[200],
                        onTap: () {
                          String roomId = chatRoomId(
                            _authService.currentUser!.email!,
                            userMap?["email"],
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ChatRoom(
                              chatRoomId: roomId,
                              userMap: userMap,
                            ),
                          ));
                        },
                        title: Text(
                          userMap?["email"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap?["name"]),
                        trailing: const Icon(
                          Icons.chat,
                          color: Color(0xFF176B87),
                        ),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GroupChatHomeScreen(),
            ),
          );
        },
        child: Icon(Icons.group),
        backgroundColor: Color(0xFF176B87),
      ),
    );
  }
}
