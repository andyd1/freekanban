import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

//import '../utils/global.dart';

class ViewCard extends StatefulWidget {
  final DocumentSnapshot? project;
  final DocumentSnapshot? swimlane;
  final DocumentSnapshot? card;

  const ViewCard({this.project, this.card, this.swimlane, Key? key})
      : super(key: key);

  @override
  State<ViewCard> createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  final formKey = GlobalKey<FormBuilderState>();

  TextEditingController? nameController;
  TextEditingController? descrController;

  String? severity;
  String? priority;
  bool? reminder;
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> cardTags = [];
  int businessValue = 0;
  int storyPoints = 0;
  int color = 0;
  String newComment = "";

  TextEditingController newCommentController = TextEditingController(text: "");


  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      Map<String, dynamic> fields = widget.card?.data() as Map<String, dynamic>;
      nameController =
          TextEditingController(text: widget.card?.get('name') ?? '');
      descrController =
          TextEditingController(text: widget.card?.get('descr') ?? '');

      severity =
      (fields.containsKey('severity')) ? widget.card?.get('severity') : "";
      priority =
      (fields.containsKey('priority')) ? widget.card?.get('priority') : "";

      color = (fields.containsKey('color'))
          ? widget.card?.get('color')
          : Colors.white.value;

      businessValue = (fields.containsKey('businessValue'))
          ? widget.card?.get('businessValue')
          : 0;
      storyPoints = (fields.containsKey('storyPoints'))
          ? widget.card?.get('storyPoints')
          : 0;

      reminder = (fields.containsKey('reminder'))
          ? widget.card?.get('reminder')
          : false;
      startDate = (fields.containsKey('startDate'))
          ? widget.card?.get('startDate')
          : null;
      endDate =
      (fields.containsKey('endDate')) ? widget.card?.get('endDate') : null;
      cardTags =
      (fields.containsKey('tags')) ? widget.card?.get('tags').toList() : [];
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tagController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editing Card"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
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
                    InkWell(
                      child: CircleAvatar(
                        backgroundColor: Color(color),
                        child: Container(),
                      ),
                      onTap: () => _changeColor(color),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.disabled,
                      name: 'descr',
                      minLines: 3,
                      maxLines: 10,
                      controller: descrController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'severity',
                      decoration: const InputDecoration(
                        labelText: 'Severity',
                      ),
                      initialValue: severity,
                      allowClear: true,
                      hint: const Text('Select Severity'),
                      validator: FormBuilderValidators.compose([
                        //  FormBuilderValidators.required()
                      ]),
                      items: ["", "Critical", "High", "Medium", "Low"]
                          .map((item) =>
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: item,
                            child: Text(item),
                          ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          severity = val;
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'priority',
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      initialValue: priority,
                      allowClear: true,
                      hint: const Text('Select Priority'),
                      validator: FormBuilderValidators.compose([
                        //  FormBuilderValidators.required()
                      ]),
                      items: ["", "Critical", "High", "Medium", "Low"]
                          .map((item) =>
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: item,
                            child: Text(item),
                          ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          priority = val;
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),

                    //TODO:  Fix suffix of picker
                    FormBuilderDateTimePicker(
                      name: 'startDate',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: startDate,
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'endDate',
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialValue: endDate,
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                      ),
                    ),
                    FormBuilderCheckbox(
                      name: 'reminder',
                      initialValue: reminder,
                      onChanged: (val) {
                        setState(() {
                          reminder = val;
                        });
                      },
                      title: const Text("Set Reminder?"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            name: 'businessValue',
                            initialValue: businessValue.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Business Value',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(),
                            ]),
                            onChanged: (value) {
                              setState(() {
                                businessValue = int.parse(value ?? '0');
                              });
                            },
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 5,
                          child: FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            name: 'storyPoints',
                            initialValue: storyPoints.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Story Points',
                            ),
                            onChanged: (value) {
                              setState(() {
                                storyPoints = int.parse(value ?? '0');
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(),

                              // FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: _getTags(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            name: 'newTag',
                            controller: tagController,
                            decoration: const InputDecoration(
                              labelText: 'Add Tag',
                            ),
                            validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.,
                            ]),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addTag(tagController.text),
                          ),
                        )
                      ],
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.disabled,
                      name: 'addComment',
                      minLines: 3,
                      maxLines: 10,
                      controller: newCommentController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                    ),
                    IconButton(onPressed: () => _addComment(),
                      icon: const Icon(Icons.add),),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('cards')
                              .doc(widget.card?.id)
                              .collection('comments')
                              .orderBy('createdDt', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading');
                            }

                            return Column(
                              children: snapshot.data!.docs.map(
                                    (DocumentSnapshot comment) {
                                  return Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListTile(
                                        title: Text(
                                          comment.get('comment'),
                                        ),
                                        subtitle: Text(
                                          comment.get('createdBy'),
                                        ),
                                      ));
                                },
                              ).toList(),
                            );
                          }),
                    ),
                    //TODO:  Checklist
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            if (formKey.currentState?.saveAndValidate() ?? false) {
              widget.card == null
                  ? FirebaseFirestore.instance.collection('cards').add({
                'createdDt': DateTime.now(),
                'name': nameController?.text,
                'descr': descrController?.text,
                'pid': widget.project?.id,
                'sid': widget.swimlane?.id,
                'order': 0,
                'priority': priority,
                'severity': severity,
                'reminder': reminder,
                'startDate': startDate,
                'endDate': endDate,
                'tags': cardTags,
                'storyPoints': storyPoints,
                'businessValue': businessValue,
                'color': color,
              })
                  : FirebaseFirestore.instance
                  .collection('cards')
                  .doc(widget.card?.id)
                  .update({
                'createdDt': DateTime.now(),
                'pid': widget.project?.id,
                'sid': widget.swimlane?.id,
                'name': nameController?.text,
                'descr': descrController?.text,
                'priority': priority,
                'severity': severity,
                'reminder': reminder,
                'startDate': startDate,
                'endDate': endDate,
                'tags': cardTags,
                'storyPoints': storyPoints,
                'businessValue': businessValue,
                'color': color,
              });
              Navigator.of(context).pop();
            } else {}
          }),
    );
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Card?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this card?'),
                Text('There is no way to recover it once deleted.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('cards')
                    .doc(widget.card?.id)
                    .delete();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
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

  _getTags() {
    List<Chip> chipList = [];

    for (String tag in cardTags) {
      chipList.add(Chip(
          label: Text(tag),
          onDeleted: () {
            setState(() {
              cardTags.remove(tag);
            });
          }));
    }
    return chipList;
  }

  _addTag(String val) {
    setState(() {
      cardTags.add(val);
    });
  }

  Future<void> _changeColor(int val) async {
    int newColor = val;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Color"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BlockPicker(
                  pickerColor: Colors.white,
                  onColorChanged: (colorVal) {
                    newColor = colorVal.value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() {
                    color = newColor;
                  });
                  Navigator.of(context).pop();
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

  _addComment() {
    FirebaseFirestore.instance.collection('cards')
        .doc(widget.card?.id)
        .collection('comments')
        .add(
        {
          'comment': newCommentController.text,
          'createdBy': FirebaseAuth.instance.currentUser?.displayName,
          'createdDt': DateTime.now(),

        }
    );
  }
}
