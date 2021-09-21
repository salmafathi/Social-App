import 'package:flutter_bloc/flutter_bloc.dart';
import 'EmailVerificationStates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EmailVerificationCubit extends Cubit<EmailVerificationStates>{
  EmailVerificationCubit() : super(EmailVerificationInitialState());

  static EmailVerificationCubit get(context) => BlocProvider.of(context);

  // send email verification
  bool isEmailSent = false ;
  void sendEmailVerification(){
    emit(SendVerificationMailLoadingState());
    FirebaseAuth.instance.currentUser!.sendEmailVerification()
        .then((value){
      isEmailSent = true ;
      emit(SendVerificationMailSuccessState());
    })
        .catchError((error){
      emit(SendVerificationMailErrorState(error.toString()));
    })
    ;
  }

// reload user
  bool isEmailVerified = false;
  Future<void> reloadUser() async {
    emit(ReloadLoadingState());
    await FirebaseAuth.instance.currentUser!.reload()
        .then((value){
      if (FirebaseAuth.instance.currentUser!.emailVerified)
       {
         isEmailVerified = true;

       }

      emit(ReloadSuccessState());
    })
        .catchError((error){
      emit(ReloadErrorState(error.toString()));
    });
  }


}