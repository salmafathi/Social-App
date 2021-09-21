import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/CommentModel.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';

class PostWithComments extends StatelessWidget {
  PostModel post ;
  int  index2 ;
  PostWithComments(this.post, this.index2);
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
     listener: (BuildContext context, Object? state){},
      builder: (BuildContext context, Object? state){
        var cubit = HomeCubit.get(context);
        var scaffKey = GlobalKey<ScaffoldState>();
       return Scaffold(
         bottomSheet: BottomSheet(
           builder: (BuildContext context)=> bottomSheetDsign(cubit),
           onClosing: () {  },),
         key: scaffKey,
         appBar: AppBar(),
         body:
         SingleChildScrollView(
           padding: EdgeInsets.only(bottom: 60),
           physics: BouncingScrollPhysics(),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               //post....................................
               postItem(cubit, context, post,index2),

               // Likes.................................
               cubit.usersWhoLikes!.length == 0 ? SizedBox():
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Likes',style: Theme.of(context).textTheme.bodyText1,),
                     Container(
                       height: 60,
                       child: ListView.separated(
                         physics:BouncingScrollPhysics(),
                         scrollDirection: Axis.horizontal,
                         itemBuilder: (context,index)=>CircleAvatar(backgroundImage: NetworkImage(cubit.usersWhoLikes![index].image.toString()),),
                         separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                         itemCount: cubit.usersWhoLikes!.length,
                       ),
                     ),
                   ],
                 ),
               ),

                //comments.............................
               cubit.allPosts[index2].postComments.length == 0 ? SizedBox():
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text('Comments',style: Theme.of(context).textTheme.bodyText1),

                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 18.0),
                       child: ListView.separated(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (context,index)=> commentItem(cubit.allPosts[index2].postComments[index],context),
                         separatorBuilder: (context,index)=>SizedBox(height: 15.0,),
                         itemCount: cubit.allPosts[index2].postComments.length,
                       ),
                     ),

                   ],
                 ),
               ),

               //write a comment ......................
               

             ],
           ),
         ),
       ) ;
      },
    );
  }


  Widget bottomSheetDsign(HomeCubit cubit){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment : MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(cubit.user!.image.toString()),),
          SizedBox(width: 5,),
          Expanded(
            child: defaultTextFormField(
                maxLines: null,
                minLines: 1,
                autofocus: true,
                suffixIcon: Icon(Icons.send,color:primaryColor),
                controller: commentController,
                keyboardType: TextInputType.text,
                hintText: 'Leave your Comment Here...',
                validator: (text){
                  if(text!.isEmpty)
                    return 'Empty Comment';
                  return null ;
                },
              suffixFun: (){
                cubit.addComment(post.postID!,CommentModel(
                  commentID: '0',
                  commentText: commentController.text,
                  commentUser: cubit.user,
                  dateTime: DateTime.now().toString()

                ));
              }

            ),
          )
        ],
      ),
    );
  }



}
