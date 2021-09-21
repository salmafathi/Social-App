import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/HomeScreen/HomeScreen.dart';
import 'package:social_app/screens/emailVerificationScreen/emailVerificationCubit/EmailVerificationCubit.dart';
import 'package:social_app/screens/emailVerificationScreen/emailVerificationCubit/EmailVerificationStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class EmailVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EmailVerificationCubit(),
      child: BlocConsumer<EmailVerificationCubit,EmailVerificationStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          var cubit = EmailVerificationCubit.get(context);
          return Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(backgroundColor: primaryColor,),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(75.0)),
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage('assets/images/email.png'),),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Email Confirmation',style:TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.w800,)),
                  SizedBox(height: 10.0,),
                  Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing',
                      style: bigTitles.bodyText2,textAlign: TextAlign.center,),
                  SizedBox(height: 45.0,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child:

                    state is SendVerificationMailLoadingState ?
                    CircularProgressIndicator()
                    : cubit.isEmailSent ?
                         Row(
                           children: [
                             Icon(Icons.check_circle_outline,color: Colors.white,),
                             Text('Email Verification Sent',style:TextStyle(color: Colors.white,fontSize: 12.0)),
                             SizedBox(width: 10.0,),
                             TextButton(onPressed: (){cubit.sendEmailVerification();}, child: Text('Send again',style: TextStyle(color: secondaryColor),))],)
                         :defaultButton(buttonFunction: (){cubit.sendEmailVerification();}, buttonText: 'Send Email',buttonColor: Colors.white,textColor: primaryColor),
                  ),

                  SizedBox(height: 15.0,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child:

                    cubit.isEmailSent ?
                       defaultButton(buttonFunction: (){
                        cubit.reloadUser().then((value) {
                          if(cubit.isEmailVerified)
                            navigateAndFinish(context, HomeScreen());
                          else{
                            makeToast('Please Verify Your Email');
                          }
                        });

                        }, buttonText: 'Verified, Go Home',buttonColor: secondaryColor)
                      : defaultButton(buttonFunction: (){}, buttonText: 'Verified, Go Home',buttonColor: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
