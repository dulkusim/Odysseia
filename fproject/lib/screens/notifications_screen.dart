import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  bool enableNotifications = true;
  bool newAward = true;
  bool challengeCompleted = false;
  bool opponentTeamProgress = false;
  bool friendAdded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2.0,
              child: SwitchListTile(
                title: const Text(
                  "Enable Notifications",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                value: enableNotifications,
                onChanged: (value) {
                  setState(() {
                    enableNotifications = value;
                  });
                },
              ),
            ),
            if (enableNotifications)
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        title: const Text(
                          "New Award",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        value: newAward,
                        onChanged: (value) {
                          setState(() {
                            newAward = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        title: const Text(
                          "Challenge Completed",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        value: challengeCompleted,
                        onChanged: (value) {
                          setState(() {
                            challengeCompleted = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        title: const Text(
                          "Opponent/Team Progress",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        value: opponentTeamProgress,
                        onChanged: (value) {
                          setState(() {
                            opponentTeamProgress = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        title: const Text(
                          "Friend Added",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        value: friendAdded,
                        onChanged: (value) {
                          setState(() {
                            friendAdded = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
