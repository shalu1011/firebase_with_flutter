import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth/email_auth/signup_screen.dart';
import 'package:firebase_phone_auth/screens/sign_in_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilePic;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((message) {
      log("testing...............");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.notification!.body.toString()),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
    });
  }

  void getInitialMessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if(message != null) {
      log(message.data["page"]);
      if(message.data["page"] == "email") {
        if(!mounted) return;
        Navigator.push(context, CupertinoPageRoute(
            builder: (context) => SignUpScreen()
        ));
      }
      else if(message.data["page"] == "phone") {

        Navigator.push(context, CupertinoPageRoute(
            builder: (context) => SignInScreen()
        ));
      }
      else {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Page!"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void saveUserToFirestore() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    int age = int.parse(ageController.text.trim());

    emailController.clear();
    nameController.clear();
    ageController.clear();

    if (name == "" || email == "" || profilePic == null) {
      log("Please fill all the fields!");
    } else {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Profilepics")
          .child(const Uuid().v1())
          .putFile(profilePic!);

      StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((snapshot) {
        double percentage =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
        log(percentage.toString());
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      taskSubscription.cancel();

      Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "age": age,
        "profilepic": downloadUrl,
        "samplearray": [name, email, age]
      };
      FirebaseFirestore.instance.collection("users").add(userData);

      log("User Created!!");
    }

    setState(() {
      profilePic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () async {
                    XFile? selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (selectedImage != null) {
                      File convertedFile = File(selectedImage.path);
                      setState(() {
                        profilePic = convertedFile;
                      });
                      log("Image Selected");
                    } else {
                      log("No Image Selected");
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        (profilePic != null) ? FileImage(profilePic!) : null,
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  onPressed: () {
                    saveUserToFirestore();
                  },
                  color: Colors.blue,
                  child: const Text("Save"),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                  // stream: FirebaseFirestore.instance
                  //     .collection("users")
                  //     .snapshots(),
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("age", isGreaterThanOrEqualTo: 24)
                      .orderBy("age", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Flexible(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> userMap =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userMap["profilepic"]),
                                  ),
                                  title: Text(userMap["name"] +
                                      " (${userMap["age"]}) "),
                                  subtitle: Text(userMap["email"]),
                                  trailing: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(snapshot.data!.docs[index].id)
                                          .delete();
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const Text("No Data");
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
