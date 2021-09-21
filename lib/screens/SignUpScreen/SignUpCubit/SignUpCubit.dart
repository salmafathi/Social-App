import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'SignUpStates.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);


  //--------SignUp Authentication-----------------------------------------
  void userSignUp({
    required String email,
    required String password,
    required String name,
    required String phone
  }) {
    emit(SignUpAuthenticationLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((value){
      CreateUser(
          email: email,
          name: name,
          userID: value.user!.uid.toString(),
          phone: phone);
     // emit(SignUpAuthenticationSuccessState());
    })
    .catchError((error){
      emit(SignUpAuthenticationErrorState(error.toString()));
    });

  }

  //--------Create User in firestore -----------------------------------------
  void CreateUser({
    required String email,
    required String name,
    required String phone,
    required String userID
  }) async {

    await FirebaseMessaging.instance.getToken().then((value){
      UserModel model = UserModel(
        name:name,
        email:email,
        phone:phone,
        uid:userID,
        isEmailVerified: false,
        image: 'https://e7.pngegg.com/pngimages/753/432/png-clipart-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-thumbnail.png',
        coverImage: 'https://fedoramagazine.org/wp-content/uploads/2017/05/f23.png-768x480.jpg',
        uPosts: [],
        uToken: value,
        friends: [] ,
      );
      FirebaseFirestore.instance.collection('users').doc(userID).set(model.toMap())
          .then((value) {
        emit(SignUpCreateUserSuccessState(userID));
      })
          .catchError((error){
        emit(SignUpCreateUserErrorState(error.toString()));
      });
    });



  }

//----------change passsword visibility suffix icon ------
  bool obsecureTextToggle = true;
  void changeSignUpPasswordVisibility() {
    obsecureTextToggle = !obsecureTextToggle;
    emit(SignUpPasswordVisibilityState());
  }
}

