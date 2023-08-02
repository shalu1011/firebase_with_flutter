import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:firebase_phone_auth/cubits/auth_cubit/auth_state.dart';
import 'package:firebase_phone_auth/email_auth/login_screen.dart';
import 'package:firebase_phone_auth/firestore_db/home.dart';
import 'package:firebase_phone_auth/screens/home_screen.dart';
import 'package:firebase_phone_auth/screens/sign_in_screen.dart';
import 'package:firebase_phone_auth/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.initialize();

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to fetch data from Firestore
  // QuerySnapshot querySnapshot = await firestore.collection("users").get();
  // for(var doc in querySnapshot.docs){
  //   log(doc.data().toString());
  // }

  // to add data in firestore
  // Map<String, dynamic> newUserData = {
  //   "name" : "amar",
  //   "email" : "amar@gmail.com"
  // };
  //await firestore.collection("users").add(newUserData);

  // add user by with your id
      // await firestore.collection("users").doc("your-id-here").set(newUserData);
      // log("new user saved!!!");

  // update user by id
  // await firestore.collection("users").doc("your-id-here").update({
  //   "email" : "amar1@gmail.com"
  // });
  // log("user updated!!!");

  //delete user
  // await firestore.collection("users").doc("your-id-here").delete();
  // log("user deleted!!!");


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),

        /** this is for bloc firebase phone auth**/
        // home:  BlocBuilder<AuthCubit, AuthState>(
        //   buildWhen: (oldState, newState){
        //     return oldState is AuthInitialState;
        //   },
        //   builder: (context, state){
        //     if(state is AuthLoggedInState){
        //       return const HomeScreen();
        //     }
        //
        //     else if(state is AuthLoggedOutState){
        //       return SignInScreen();
        //     }
        //
        //     else{
        //       return const Scaffold();
        //     }
        //
        //   },
        // ),

        /** this is for simple firebase email auth**/
        //home: (FirebaseAuth.instance.currentUser != null) ? const HomeScreen() : const LoginScreen(),

        home: const Home(),

      ),
    );
  }
}




// SHA1: 58:56:2C:C3:9E:D4:12:E6:AF:2D:7D:D0:0F:A8:42:F2:09:A1:72:56
// SHA-256: 35:AE:B7:FC:44:A6:DF:98:F9:21:FA:2A:9D:7B:16:3A:E6:87:D9:DF:1F:06:6C:39:70:2F:B8:26:71:2F:31:55
