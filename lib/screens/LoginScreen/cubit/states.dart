
import 'package:social_app/models/UserModel.dart';

abstract class LoginState {}
class LoginInitialState extends LoginState {}
class LoginLoadingState extends LoginState {}
class LoginSuccessState extends LoginState {
  late final String userID;
   LoginSuccessState(this.userID);
}
class LoginErrorState extends LoginState {
   final String? errorString ;
  LoginErrorState(this.errorString);

}

class PasswordVisibilityState extends LoginState {}

// get user Reload states
class LoginReloadLoadingState extends LoginState {}
class LoginReloadSuccessState extends LoginState {}
class LoginReloadErrorState extends LoginState {
  final String? errorString ;
  LoginReloadErrorState(this.errorString);
}