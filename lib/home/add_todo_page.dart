import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_myapp/model/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _fromKey = GlobalKey<FormState>();
  bool _isCompleted = false;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _author = TextEditingController();

  Future<void> addTodo() async {
    final db = FirebaseFirestore.instance;
    final todo = ToDo(
      title: _title.text,
      description: _description.text,
      isCompleted: _isCompleted,
      author: _author.text,
    );
    await db.collection('todos').add(todo.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AddTodopage"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Form(
          key: _fromKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  hintText: "title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _description,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: "description",
                  border: OutlineInputBorder(),
                ),
              ),
              CheckboxListTile(
                  title: const Text(" Is completed"),
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value ?? false;
                    });
                  }),
              const SizedBox(height: 40),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                  hintText: "author",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter author name";
                  }
                  return null;
                },
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_fromKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const CupertinoAlertDialog(
                            title: Text("Please waiting"),
                            content: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: CupertinoActivityIndicator(
                                  radius: 30,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      await addTodo();
                      // ignore: use_build_context_synchronously
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.paperPlane),
                  label: const Text("push"))
            ],
          ),
        ),
      ),
    );
  }
}
