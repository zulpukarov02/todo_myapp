import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_myapp/home/add_todo_page.dart';
import 'package:todo_myapp/model/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    readTodos();
  }

  Stream<QuerySnapshot> readTodos() {
    final db = FirebaseFirestore.instance;
    return db.collection("todos").snapshots();
  }

  Future<void> updateTodo(ToDo todo) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("todos")
        .doc(todo.id)
        .update({"isCompleted": !todo.isCompleted});
  }

  Future<void> deletTodo(ToDo todo) async {
    final db = FirebaseFirestore.instance;
    await db.collection("todos").doc(todo.id).delete();
  }
  // Future<void> readTodos() async {
  //   final db = FirebaseFirestore.instance;
  //   await db.collection("todos").get().then((event) {
  //     for (var doc in event.docs) {
  //       // print("${doc.id} => ${doc.data()}");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: readTodos(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error!.toString()));
          } else if (snapshot.hasData) {
            final List<ToDo> todos =
                // ignore: unnecessary_cast
                snapshot.data!.docs
                    // ignore: unnecessary_cast
                    .map((d) => ToDo.fromMap(d.data() as Map<String, dynamic>)
                      ..id = d.id)
                    .toList();
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.isCompleted,
                          onChanged: (v) async {
                            await updateTodo(todo);
                          },
                        ),
                        IconButton(
                            onPressed: () async {
                              await deletTodo(todo);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.description ?? ''),
                        Text(todo.author),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("ERROR"));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
