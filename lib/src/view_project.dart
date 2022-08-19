import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:freekanban/src/home_page.dart';
import 'package:freekanban/src/project_settings.dart';
import 'package:freekanban/src/view_card.dart';
import 'package:freekanban/utils/global.dart';

class ViewProject extends StatefulWidget {
  final DocumentSnapshot project;

  const ViewProject(this.project, {Key? key}) : super(key: key);

  @override
  State<ViewProject> createState() => _ViewProjectState();
}

//TODO:  Highlight drag targets when hovered
//TODO:  Add more details to cards
class _ViewProjectState extends State<ViewProject> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.project.get('name')),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectSettings(widget.project)),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: const Icon(Icons.home),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('swimlanes')
                  .where('pid', isEqualTo: widget.project.id)
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot swimlane) {
                      return Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width / 3.1,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              DragTarget<DocumentSnapshot>(
                                onWillAccept: (DocumentSnapshot? data) {
                                  bool accept = false;
                                  if (data?.id != swimlane.id) {
                                    accept = true;
                                  }
                                  return accept;
                                },
                                onAccept: (DocumentSnapshot data) {
                                  FirebaseFirestore.instance
                                      .collection('cards')
                                      .doc(data.id)
                                      .update({'sid': swimlane.id, 'order': 0});
                                },
                                builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Column(
                                    children: [
                                      Text(swimlane.get('name')),
                                      IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ViewCard(
                                                      project: widget.project,
                                                      swimlane: swimlane,
                                                      card: null)),
                                            );
                                          }),

                                    ],
                                  );
                                },
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('cards')
                                        .where('sid', isEqualTo: swimlane.id)
                                        .orderBy('order')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text('Loading');
                                      }
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot card) {
                                            return LongPressDraggable(
                                              //TODO:  Allow scrolling while dragging
                                              data: card,
                                              feedback: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: _getCard(card)),
                                              child:
                                                  DragTarget<DocumentSnapshot>(
                                                builder: (
                                                  BuildContext context,
                                                  List<dynamic> accepted,
                                                  List<dynamic> rejected,
                                                ) {
                                                  return InkWell(
                                                    onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewCard(
                                                                  project: widget
                                                                      .project,
                                                                  swimlane:
                                                                      swimlane,
                                                                  card: card)),
                                                    ),
                                                    child: _getCard(card),
                                                  );
                                                },
                                                onMove: (_) {},
                                                onAccept:
                                                    (DocumentSnapshot data) {
                                                  FirebaseFirestore.instance
                                                      .collection('cards')
                                                      .doc(data.id)
                                                      .update({
                                                    'sid': card.get('sid'),
                                                    'order':
                                                        card.get('order') + 1
                                                    //TODO: need to move all lower cards
                                                  });
                                                },
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ));
                    },
                  ).toList(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          //onPressed: () => _addProject(),
          onPressed: () {
            final formKey = GlobalKey<FormBuilderState>();
            TextEditingController nameController =
            TextEditingController(text: "");

            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  child: const Text('Save'),
                                  onPressed: () {
                                    if (formKey.currentState?.saveAndValidate() ?? false) {
                                      FirebaseFirestore.instance
                                          .collection('swimlanes')
                                          .add({
                                        'createdDt': DateTime.now(),
                                        'name': nameController.text,
                                        'pid': widget.project.id,
                                        'order': 0,
                                      });

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
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  _getCard(DocumentSnapshot card) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 5,
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: Column(
          children: [
            Text(
              card.get('name'),
              style: titleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
