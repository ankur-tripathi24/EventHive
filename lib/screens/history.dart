import 'package:eventhive/service/database.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late final DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  List<List<Color>> colors = <List<Color>>[
    [Color(0xFF001C30), Colors.blueAccent],
    [Color(0xFF176B87), Colors.blue],
    [Color(0xFF64CCC5), Colors.blue]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF176B87),
      ),
      body: FutureBuilder(
          future: databaseService.getRegisteredHackathons(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // TODO: Handle this case.
                return const Center(
                  child: Text('No data'),
                );
              case ConnectionState.waiting:
                // TODO: Handle this case.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                // TODO: Handle this case.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.data!.length == 0) {
                  return const Center(
                    child: Text('Not registered for any hackathons'),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      itemCount:
                          snapshot.data!.length, // total number of list items
                      itemBuilder: (BuildContext context, int currentitem) {
                        return GestureDetector(
                          onTap: () {
                            print("tapped on item $currentitem");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF64CCC5),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 3.5,
                                  offset: Offset(1.0, 2.0),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            height: 150,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  //left half image avatar of list item
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(left: 20, top: 15),
                                    child: CircleAvatar(
                                      backgroundImage: Image.network(snapshot
                                              .data![currentitem]?['image'])
                                          .image,
                                      radius: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  //center of list item
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(top: 20, left: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data![currentitem]
                                                      ?['name'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(snapshot.data![currentitem]
                                                    ?['domain']),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text("Prize Money"),
                                                    Text(
                                                      snapshot.data![
                                                              currentitem]
                                                          ?['prize_money'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   flex: 7,
                                            //   child: Container(
                                            //     child: Column(
                                            //       children: <Widget>[
                                            //         Text("Organized By"),
                                            //         Text(
                                            //           snapshot.data![
                                            //                   currentitem]
                                            //               ?['organizer'],
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  //right half of list item
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.more_horiz),
                                          onPressed: () {},
                                        ),
                                        Text(
                                            // snapshot.data![currentitem]
                                            //             ?['start_time']
                                            //         .toString()
                                            //         .substring(0, 10) ??
                                            "Not Started",
                                            style: TextStyle(fontSize: 16)),
                                        Text("Remaining Time"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              default:
                return const Center(
                  child: Text('No data'),
                );
            }
          })),
    );
  }
}
