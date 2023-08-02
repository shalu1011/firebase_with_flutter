import 'package:firebase_phone_auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:firebase_phone_auth/cubits/auth_cubit/auth_state.dart';
import 'package:firebase_phone_auth/screens/verify_phone_no.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
   SignInScreen({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In with Phone"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
               TextField(
                controller: controller,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Phone Number",
                    counterText: ""),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state){
                 if(state is AuthCodeSentState){
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifyPhoneNo()));
                 }
                } ,
                 builder: (context, state){
                  if(state is AuthLoadingState){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                   return SizedBox(
                       width: MediaQuery.sizeOf(context).width,
                       child: CupertinoButton(
                         onPressed: () {
                            String phoneNo = "+91${controller.text}";
                            BlocProvider.of<AuthCubit>(context).sendOTP(phoneNo);
                         },
                         color: Colors.blue,
                         child: const Text("Sign In"),
                       ));
                 },
              )
            ],
          ),
        ),
      ),
    );
  }
}
