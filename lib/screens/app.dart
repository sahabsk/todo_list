import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/screens/add_task.dart';
import 'package:todo_list/screens/description.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List Firebase"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blueGrey,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              final document = snapshot.data.docs;
              return ListView.builder(
                itemCount: document.length,
                itemBuilder: (context, index) {
                  var time =
                      (document[index]['timestamp'] as Timestamp).toDate();
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                  title: document[index]['title'],
                                  description: document[index]
                                      ['description'])));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  document[index]['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.lato().fontFamily),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                    DateFormat.yMd().add_jm().format(time)),
                              )
                            ],
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 26,
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(uid)
                                    .collection('mytasks')
                                    .doc(document[index]['time'])
                                    .delete();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
      ),
      drawer: Drawer(),
    );
  }
}
