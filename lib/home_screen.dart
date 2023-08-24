import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_op/validator.dart';
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
      appBar: AppBar(
        title: const Text("Firebase CRUD Operation"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = snap.data!.docs[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: 'Name:        ',
                                    text: user["name"],
                                  ),
                                  CustomText(
                                    title: 'Age:            ',
                                    text: user["age"],
                                  ),
                                  CustomText(
                                    title: 'Phone No:  ',
                                    text: user["phoneNo"],
                                  ),
                                  CustomText(
                                    title: 'Email:         ',
                                    text: user["email"],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _showAlertDialog(
                                          context: context,
                                          name: user["name"],
                                          age: user["age"],
                                          email: user["email"],
                                          phoneNo: user["phoneNo"],
                                          user: user,
                                          state: 1);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      QuerySnapshot snapshot =
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .where("email",
                                                  isEqualTo: user["email"])
                                              .get();
                                      String docId = snapshot.docs.first.id;
                                      DocumentReference documentRef =
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(docId);

                                      documentRef.delete();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text("Failed to Load Datas");
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlertDialog(
              context: context,
              name: "",
              age: "",
              email: "",
              phoneNo: "",
              state: 0);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAlertDialog(
      {required BuildContext context,
      required String name,
      required String age,
      required String phoneNo,
      required String email,
      var user,
      required int state}) {
    _nameController.text = name;
    _ageController.text = age;
    _emailController.text = email;
    _phoneNoController.text = phoneNo;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  onChanged: (val) => name = val,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  onChanged: (val) => age = val,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _phoneNoController,
                  onChanged: (val) => phoneNo = val,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _emailController,
                  onChanged: (val) => email = val,
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
                onPressed: () async {
                  if (validateInputs(name, age, phoneNo, email, context)) {
                    if (state == 0) {
                      users.add({
                        "name": name,
                        "age": age,
                        "phoneNo": phoneNo,
                        "email": email
                      });
                    } else {
                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                          .collection("users")
                          .where("email", isEqualTo: user["email"])
                          .get();
                      String docId = snapshot.docs.first.id;
                      DocumentReference documentRef = FirebaseFirestore.instance
                          .collection("users")
                          .doc(docId);

                      documentRef.update({
                        "age": "22",
                        "name": "Lotus",
                        "phoneNo": "9364382912",
                        "email": "ayesh@gmail.com"
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }
}

class CustomText extends StatelessWidget {
  final String title;
  final String text;
  const CustomText({Key? key, required this.title, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black38),
        TextSpan(
            text: title,
            //style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Colors.black38),
            children: <InlineSpan>[
              TextSpan(
                text: text,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ]));
  }
}
