
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/LoginScreen/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  //--------Login-----------------------------------------
  Future<void> userLogin ({
    required String email,
    required String password
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    })
    .catchError((error){
      emit(LoginErrorState(error.toString()));
    });

//          emit(LoginErrorState(error.toString()));

  }

  //----------change passsword visibility suffix icon ------
    bool obsecureTextToggle = true;
    void changePasswordVisibility() {
      obsecureTextToggle = !obsecureTextToggle;
      emit(PasswordVisibilityState());
    }


  // -----------------------------------reload user
  bool isEmailVerified = false;
  Future<void> LoginreloadUser() async {
    emit(LoginReloadLoadingState());
    await FirebaseAuth.instance.currentUser!.reload()
        .then((value){
      if (FirebaseAuth.instance.currentUser!.emailVerified)
      {
        isEmailVerified = true;

      }

      emit(LoginReloadSuccessState());
    })
        .catchError((error){
      emit(LoginReloadErrorState(error.toString()));
    });
  }
  }

