import 'package:flutter/material.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/ChatDetails/ChatDetails.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (BuildContext context, Object? state) {},
        builder : (BuildContext context, Object? state){
          var cubit = HomeCubit.get(context);

        return
        cubit.chatUsers.length > 0 ?
          ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index) => chatItem(cubit.chatUsers[index],context),
            separatorBuilder: (context,index) =>Container(height: 1.0, width: double.infinity,color: Colors.grey.shade300,),
            itemCount: cubit.chatUsers.length)

           :  Center(child: CircularProgressIndicator(),);
      }
    );
  }
  
  Widget chatItem (UserModel chatUser,context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (contextProfile){
            return BlocProvider.value(
              value: HomeCubit.get(context)..getMessages(receiverID: chatUser.uid.toString()),
              child: ChatDetails(chatUser),
            );
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundImage : NetworkImage(chatUser.image.toString()),),
            SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(chatUser.name.toString(),style: Theme.of(context).textTheme.bodyText2,),
                    SizedBox(width: 5.0,),
                    Icon(Icons.check_circle,color: primaryColor,size: 16.0,),
                  ],
                ),
             //   Text(daysBetween(DateTime.parse('')),style: Theme.of(context).textTheme.caption)
              ],
            ),



          ],
        ),
      ),
    ) ;
  }
}
