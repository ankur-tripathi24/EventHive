import 'package:eventhive/components/card_widget.dart';
import 'package:eventhive/screens/navigation.dart';
import 'package:eventhive/service/database.dart';
import 'package:eventhive/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late final _screenHeight = MediaQuery.of(context).size.height;
  final databaseService = DatabaseService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                'login',
                (route) => false,
              );
            },
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) {},
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text('Profile'),
                  value: MenuAction.profile,
                ),
                const PopupMenuItem(
                  child: Text('Settings'),
                  value: MenuAction.settings,
                ),
                const PopupMenuItem(
                  child: Text('Logout'),
                  value: MenuAction.logout,
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: databaseService.getHackathons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data as List<Map<String, dynamic>?>;
            print(data);
            return Column(
              children: [
                SizedBox(
                  height: _screenHeight * 0.1,
                ),
                SizedBox(
                  height: _screenHeight * 0.5,
                  child: Swiper(
                    itemCount: data.length,
                    itemHeight: _screenHeight * 0.5,
                    itemWidth: MediaQuery.of(context).size.width * 0.9,
                    itemBuilder: (context, index) {
                      return data.isNotEmpty
                          ? CardWidget(
                              imageUrl: data[index]!['image'],
                              title: data[index]!['name'],
                              description: data[index]!['description'],
                              map: data[index]!,
                            )
                          : const Center(
                              child: Text('No data available'),
                            );
                    },
                    pagination: null,
                    control: const SwiperControl(
                      color: const Color(0xFF176B87),
                    ),
                    onTap: ((index) {
                      print('Tapped on $index');
                    }),
                    layout: SwiperLayout.CUSTOM,
                    customLayoutOption:
                        CustomLayoutOption(startIndex: -1, stateCount: 3)
                          ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
                          ..addTranslate([
                            const Offset(-370.0, -40.0),
                            const Offset(0.0, 0.0),
                            const Offset(370.0, -40.0)
                          ]),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

enum MenuAction { profile, settings, logout }
