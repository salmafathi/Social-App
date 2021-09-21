import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/MessageModel.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatDetails extends StatelessWidget {
  var sendMessageController = TextEditingController();
  var listController = ScrollController();
  var formKey = GlobalKey<FormState>();
  UserModel receiverUser ;
  ChatDetails(this.receiverUser);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (BuildContext context, Object? state) {
        if(state is SendMessageSuccessState)
        {
          sendMessageController.clear();
          Timer(Duration(seconds: 1), ()=>listController.jumpTo(listController.position.maxScrollExtent));
        }
        },
      builder : (BuildContext context, Object? state){
         var cubit = HomeCubit.get(context);
         if(cubit.messages.length > 0)
           Timer(Duration(seconds: 1), ()=>listController.jumpTo(listController.position.maxScrollExtent));
         return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(receiverUser.image.toString()),
                  ),
                  SizedBox(width: 10,),
                  Text(receiverUser.name.toString()),

                ],
              ),

            ),
            bottomSheet: BottomSheet(
              builder: (BuildContext context)=> bottomSheetDesign(cubit,state),
              onClosing: () {  },
            ),

            body :
            state is GetMessageLoadingState ? Center(child: CircularProgressIndicator(),) :
            cubit.messages.length > 0 ? Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 100),
              child: Expanded(
                child: ListView.separated(
                    controller: listController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)
                    {
                      if(cubit.messages[index].senderID == cubit.user!.uid)
                        return sendMessage(cubit.messages[index],context) ;
                      else
                        return receiveMessage(cubit.messages[index],context) ;
                    },
                    separatorBuilder: (context,index) => SizedBox(height: 15,),
                    itemCount: cubit.messages.length ),
              ),
            )  :  Center(child: Text('Start your first chat'),)
          );
      }
    );

  }

  Widget bottomSheetDesign(HomeCubit cubit, Object? state){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment : MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(cubit.user!.image.toString()),),
          SizedBox(width: 5,),
          Expanded(
            child: Form(
              key: formKey,
              child: defaultTextFormField(
                 // enabled: state is SendMessageSuccessState ? false : true,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  suffixIcon: Icon(Icons.send,color:primaryColor),
                  controller: sendMessageController,
                  keyboardType: TextInputType.text,
                  hintText: 'Send Message...',
                  validator: (text){
                    if(text!.isEmpty)
                      return 'Empty Message';
                    return null ;
                  },
                  suffixFun: (){
                    if (formKey.currentState!.validate())
                        cubit.sendMessage(
                            receiverID: receiverUser.uid.toString(),
                            dateTime: DateTime.now().toString(),
                            text: sendMessageController.text,
                            receiverUser: receiverUser);
                      }

              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sendMessage (MessageModel message,context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: primaryColor.shade100,
              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(10.0),topStart: Radius.circular(10.0),bottomEnd: Radius.circular(10.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(message.text.toString()),
              ),
              SizedBox(height: 5,),
              Text(daysBetween(DateTime.parse(message.dateTime.toString())),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )),
    );
  }

  Widget receiveMessage(MessageModel message,context){
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(10.0),topStart: Radius.circular(10.0),bottomStart: Radius.circular(10.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(message.text.toString()),
              ),
              SizedBox(height: 5,),
              Text(daysBetween(DateTime.parse(message.dateTime.toString())),
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10),
              ),

            ],
          )),
    );
  }
}
