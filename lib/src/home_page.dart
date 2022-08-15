import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:freekanban/src/user_profile.dart';
import 'package:freekanban/src/view_project.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("home")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfile()),
                );
              },
            ),
            ListTile(
              title: const Text('Legal'),
              onTap: () {
                const ProfileScreen();
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              }
              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: snapshot.data!.docs.map((DocumentSnapshot project) {
                  return Card(
                    elevation: 10,
                    color: Color(project.get('color')),
                    child: ListTile(
                      title: Text(project.get('name')),
                      onTap: () => _viewProject(project),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addProject(),
      ),
    );
  }

  Future<void> _addProject() {
    final formKey = GlobalKey<FormBuilderState>();
    TextEditingController nameController = TextEditingController(text: "");

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Project'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: formKey,
                  // enabled: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  skipDisabled: true,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.disabled,
                        name: 'name',
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    //create project
                    FirebaseFirestore.instance.collection('projects').add({
                      'createdDt': DateTime.now(),
                      'name': nameController.text,
                      'uid': FirebaseAuth.instance.currentUser?.uid,
                      'color': 4294967295,
                    }).then((doc) {
                      FirebaseFirestore.instance.collection('swimlanes').add({
                        'createdDt': DateTime.now(),
                        'name': "To Do",
                        'pid': doc.id,
                        'order': 0,
                      });
                    }); //add initial swimlane

                    Navigator.of(context).pop();
                  } else {}
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _viewProject(DocumentSnapshot project) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewProject(project)),
    );
  }
}
