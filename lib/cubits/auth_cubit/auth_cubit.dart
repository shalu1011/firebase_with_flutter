import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth/cubits/auth_cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState()){
    User? _currentUser = _auth.currentUser;

    if(_currentUser != null){
      emit(AuthLoggedInState(_currentUser));
    }
    else{
      emit(AuthLoggedOutState());
    }

  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  void sendOTP(String phoneNo) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          emit(AuthCodeSentState());
        },
        verificationCompleted: (phoneAuthCredential) {
          signInWithPhone(phoneAuthCredential);
        },
        verificationFailed: (error) {
          emit(AuthErrorState(error.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = _verificationId;
        }
    );
  }

  void signInWithPhone(PhoneAuthCredential credential) async{
    try{
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if(userCredential.user != null){
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch(ex){
      emit(AuthErrorState(ex.message.toString()));
    }
  }

  void verifyOTP(String otp){
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otp);
    signInWithPhone(credential);
  }

  void logOut() async{
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}