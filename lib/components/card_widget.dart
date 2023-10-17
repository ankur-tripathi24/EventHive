import 'package:eventhive/screens/team_registration.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Map<String, dynamic> map;

  const CardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          // Image at the top
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.width *
                  0.5, // Customize the image height as needed
              fit: BoxFit.cover,
            ),
          ),
          // Details below the image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF176B87)),
                    child: IconButton(
                      icon: const Icon(
                        Icons.details,
                        color: Colors.white,
                      ),
                      onPressed: (() {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Details(
                                name: map['name'],
                                description: map['description'],
                                image: map['image'],
                                domain: map['domain'],
                                startTime: map['start_time'].toDate(),
                                endTime: map['end_time'].toDate(),
                                organizer: map['organizer'],
                                prizeMoney: map['prize_money'],
                              );
                            });
                      }),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF176B87),
                  ),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TeamRegistrationForm(
                                  data: map,
                                )));
                      },
                      icon: const Icon(
                        Icons.app_registration_rounded,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final String domain;
  final DateTime startTime;
  final DateTime endTime;
  final String organizer;
  final String prizeMoney;

  Details({
    required this.name,
    required this.description,
    required this.image,
    required this.domain,
    required this.startTime,
    required this.endTime,
    required this.organizer,
    required this.prizeMoney,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the remaining time between the current time and end time
    final currentTime = DateTime.now();
    final remainingTime = endTime.isAfter(currentTime)
        ? endTime.difference(currentTime)
        : Duration.zero;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Display the event details
          Image.network(image, height: 150),
          Text(name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Text(description),
          ),
          Text('Domain: $domain'),
          Text('Organizer: $organizer'),
          Text('Prize Money: $prizeMoney'),

          // Display the countdown timer
          CountdownTimer(endTime: endTime, remainingTime: remainingTime),
        ],
      ),
    );
  }
}

class CountdownTimer extends StatelessWidget {
  final DateTime endTime;
  final Duration remainingTime;

  CountdownTimer({
    required this.endTime,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Countdown Timer:'),
        Text(
          '${remainingTime.inDays} days, ${remainingTime.inHours % 24} hours',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
