import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp':time,
    });
    // Fluttertoast.showToast(msg: 'Data Added');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task Added successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                // keyboardType: TextInputType.text,
                controller: titleController,
                decoration: InputDecoration(
                    labelText: "Enter the Title", border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: "Enter the Title", border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.roboto().fontFamily),
                ),
                onPressed: () {
                  addTaskToFirebase();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
