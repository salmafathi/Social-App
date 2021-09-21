abstract class EmailVerificationStates {}

class EmailVerificationInitialState extends EmailVerificationStates {}


// user send verification mail states
class SendVerificationMailLoadingState extends EmailVerificationStates {}
class SendVerificationMailSuccessState extends EmailVerificationStates {}
class SendVerificationMailErrorState extends EmailVerificationStates {
  final String? errorString ;
  SendVerificationMailErrorState(this.errorString);
}

// get user Reload states
class ReloadLoadingState extends EmailVerificationStates {}
class ReloadSuccessState extends EmailVerificationStates {}
class ReloadErrorState extends EmailVerificationStates {
  final String? errorString ;
  ReloadErrorState(this.errorString);
}