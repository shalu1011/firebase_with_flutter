import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth/email_auth/login_screen.dart';
import 'package:firebase_phone_auth/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/auth_cubit/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
            child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOutState) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            }
          },
          builder: (context, state) {
            return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: CupertinoButton(
                  onPressed: () {
                    /** this is for bloc firebase phone auth**/
                    // BlocProvider.of<AuthCubit>(context).logOut();

                    /** this is for  firebase email auth**/
                    logout(context);
                  },
                  child: const Text("Log Out"),
                ));
          },
        )));
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
