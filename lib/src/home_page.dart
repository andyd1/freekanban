import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import '../config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("home")),
      body: Container(
          child: Column(
        children: [
          ElevatedButton(onPressed: () => _profile(), child: Text("Profile")),
          ElevatedButton(onPressed: () => _logout(), child: Text("Logout")),
          SignOutButton(),

        ],
      )),
    );
  }

  _profile() {
    return ProfileScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: GOOGLE_CLIENT_ID,
        ),
      ],
      avatarSize: 24,
    );
  }

  _logout() {
  }
}

