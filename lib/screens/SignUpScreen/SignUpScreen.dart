import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/HomeScreen/HomeScreen.dart';
import 'package:social_app/screens/LoginScreen/LoginScreen.dart';
import 'package:social_app/screens/SignUpScreen/SignUpCubit/SignUpCubit.dart';
import 'package:social_app/screens/SignUpScreen/SignUpCubit/SignUpStates.dart';
import 'package:social_app/screens/emailVerificationScreen/EmailVerificationScreen.dart';
import 'package:social_app/shared/Network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/styles.dart';

class SignUpScreen extends StatelessWidget {

  var nameConteroller = TextEditingController();
  var emailConteroller = TextEditingController();
  var phoneConteroller = TextEditingController();
  var passwordConteroller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit,SignUpState>(
      listener: (BuildContext context, state){
        if(state is SignUpCreateUserSuccessState){
          CachHelper.putDataInSharedPreference(
              value: state.userID,
              key: 'uID')
              .then((value) {
                uID =  state.userID ;
             navigateTo(context, EmailVerificationScreen());
          });
        }

        else if(state is SignUpAuthenticationErrorState){
          makeToast('${state.errorString}');
        }
        else if (state is SignUpCreateUserErrorState){
          makeToast('${state.errorString}');
        }


      },
        builder: (BuildContext context, state){
        return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text('SIGN UP',
                        style: bigTitles.headline5),
                    SizedBox(height: 10.0,),
                    Text('Welcome to Shop app, please sign up',
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(height: 45.0,),

                    defaultTextFormField(
                        validator: (String? text) {
                          if(text!.isEmpty)
                            return 'please enter valid email';
                        },
                        controller: nameConteroller,
                        labelText: 'name',
                        keyboardType: TextInputType.name,
                        prefixIcon: Icon(Icons.person)
                    ),

                    SizedBox(height: 15.0,),

                    defaultTextFormField(
                        validator: (String? text) {
                          if(text!.isEmpty)
                            return 'please enter valid email';
                        },
                        controller: emailConteroller,
                        labelText: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email)
                    ),
                    SizedBox(height: 15.0,),

                    defaultTextFormField(
                        validator: (String? text) {
                          if(text!.isEmpty)
                            return 'please enter valid email';
                        },
                        controller: phoneConteroller,
                        labelText: 'phone',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(Icons.phone)
                    ),
                    SizedBox(height: 15.0,),

                    defaultTextFormField(
                        validator: (String? text) {
                          if(text!.isEmpty)
                            return 'please enter valid password';
                        },
                        controller: passwordConteroller,
                        labelText: 'password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: SignUpCubit.get(context).obsecureTextToggle ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                        obscureText:SignUpCubit.get(context).obsecureTextToggle,
                        suffixFun: (){SignUpCubit.get(context).changeSignUpPasswordVisibility();}
                        ,
                        onSubmit: (value){
                          if(formKey.currentState!.validate())
                          {
                             SignUpCubit.get(context).userSignUp(email: emailConteroller.text, password: passwordConteroller.text,name: nameConteroller.text,phone: phoneConteroller.text);
                          }
                        }
                    ),



                    SizedBox(height: 15.0,),

                    state is! SignUpAuthenticationLoadingState ?
                    defaultButton(
                      buttonFunction: () {
                        if(formKey.currentState!.validate())
                        {
                          SignUpCubit.get(context).userSignUp(email: emailConteroller.text, password: passwordConteroller.text,name: nameConteroller.text,phone: phoneConteroller.text);
                        }
                      },
                      buttonText: 'Sign Up',
                    )
                        : Center(child: CircularProgressIndicator(),),


                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have an account?',style: Theme.of(context).textTheme.bodyText1),
                        TextButton(onPressed: () {
                          navigateAndFinish(context, LoginScreen());
                        }, child: Text('Login',)),
                      ],
                    ),



                  ],
                ),
              ),
            ),
          ),
        ) ;
        },

      ),
    ) ;
  }
}
