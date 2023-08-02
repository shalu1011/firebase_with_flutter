import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/auth_cubit/auth_state.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class VerifyPhoneNo extends StatelessWidget {
   VerifyPhoneNo({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Phone Number"),
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
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "6-digit OTP",
                    counterText: ""),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state){
                  if(state is AuthLoggedInState){
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const HomeScreen()));
                  }

                  else if(state is AuthErrorState){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error), backgroundColor: Colors.red, duration: const Duration(minutes: 1),)
                    );
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
                          BlocProvider.of<AuthCubit>(context).verifyOTP(controller.text);
                        },
                        color: Colors.blue,
                        child: const Text("Verify"),
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
