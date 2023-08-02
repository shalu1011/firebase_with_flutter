import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth/email_auth/signup_screen.dart';
import 'package:firebase_phone_auth/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      log("Please fill all the fields!");
    }
    else {
      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if(userCredential.user != null){
          if (!mounted) return;
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context) => const HomeScreen()
          ));
        }

      } on FirebaseAuthException catch(ex){
        final snackBar = SnackBar(content: Text(ex.code.toString()), backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
      ),
      body: SafeArea(
        child: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email Address"
                    ),
                  ),

                  const SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: "Password"
                    ),
                  ),

                  const SizedBox(height: 20,),

                  CupertinoButton(
                    onPressed: () {
                      login();
                    },
                    color: Colors.blue,
                    child: const Text("Log In"),
                  ),

                  const SizedBox(height: 10,),

                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => const SignUpScreen()
                      ));
                    },
                    child: const Text("Create an Account"),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}