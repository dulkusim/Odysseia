import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  bool enableNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
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
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: enableNotifications,
            onChanged: (value) {
              setState(() {
                enableNotifications = value;
              });
            },
          ),
          if (enableNotifications)
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: const Text("New Award"),
                    value: true,
                    onChanged: (value) {},
                  ),
                  CheckboxListTile(
                    title: const Text("Challenge Completed"),
                    value: false,
                    onChanged: (value) {},
                  ),
                  CheckboxListTile(
                    title: const Text("Opponent/Team Progress"),
                    value: false,
                    onChanged: (value) {},
                  ),
                  CheckboxListTile(
                    title: const Text("Friend Added"),
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
