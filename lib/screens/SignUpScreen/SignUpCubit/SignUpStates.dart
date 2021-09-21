
abstract class SignUpState {}
class SignUpInitialState extends SignUpState {}

// sign up  firebase Authentication states
class SignUpAuthenticationLoadingState extends SignUpState {}
class SignUpAuthenticationSuccessState extends SignUpState {
}
class SignUpAuthenticationErrorState extends SignUpState {
  final String? errorString ;
  SignUpAuthenticationErrorState(this.errorString);

}

//sign up firestore create user states
class SignUpCreateUserLoadingState extends SignUpState {}
class SignUpCreateUserSuccessState extends SignUpState {
  late final String userID;
  SignUpCreateUserSuccessState(this.userID);
}
class SignUpCreateUserErrorState extends SignUpState {
  final String? errorString ;
  SignUpCreateUserErrorState(this.errorString);

}

class SignUpPasswordVisibilityState extends SignUpState {}

