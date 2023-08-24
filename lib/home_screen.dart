import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
final TextEditingController _nameController = TextEditingController();
final TextEditingController _ageController = TextEditingController();
final TextEditingController _phoneNoController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = snap.data!.docs[index];

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(user["name"]),
                          IconButton(
                            onPressed: () async {
                              QuerySnapshot snapshot = await FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .where("email", isEqualTo: user["email"])
                                  .get();
                              String docId = snapshot.docs.first.id;
                              DocumentReference documentRef = FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .doc(docId);

                              documentRef.delete();
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () async {
                              QuerySnapshot snapshot = await FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .where("email", isEqualTo: user["email"])
                                  .get();
                              String docId = snapshot.docs.first.id;
                              DocumentReference documentRef = FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .doc(docId);

                              documentRef.update({
                                "age": "22",
                                "name": "Lotus",
                                "phoneNo": "9364382912",
                                "email": "ayesh@gmail.com"
                              });
                            },
                            icon: Icon(Icons.edit),
                          )
                        ],
                      ),
                      Text(user["age"].toString()),
                      Text(user["phoneNo"]),
                      Text(user["email"]),
                    ],
                  );
                },
              );
            } else {
              return Text("Failed to Load Datas");
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  users.add({
                    "name": _nameController.text,
                    "age": _ageController.text,
                    "phoneNo": _phoneNoController.text,
                    "email": _emailController.text
                  });
                  // Perform action with entered data
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }
}
