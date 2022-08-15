import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectSettings extends StatefulWidget {
  final DocumentSnapshot? project;
  const ProjectSettings(this.project, {Key? key}) : super(key: key);

  @override
  State<ProjectSettings> createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  @override
  Widget build(BuildContext context) {
    //TODO:  Swimlane Management
    //TODO:  Membership Management
    //TODO:  Custom Fields
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Settings"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text("settings")
              //TODO:  Form for name, color
            ],
          ),
        ),
      ),
    );
  }
}
