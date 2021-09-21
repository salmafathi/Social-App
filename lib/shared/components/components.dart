import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/CommentModel.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/PostLikesScreen/PostLikesScreen.dart';
import 'package:social_app/screens/PostWithComments/PostWithComments.dart';
import 'package:social_app/screens/profileScreen/ProfileScreen.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';




void navigateTo(context,widget) => Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_)=>widget,));

void navigateAndFinish(context,widget)=> Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>widget),
    (Route<dynamic> route) => false,);


Widget defaultTextFormField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? labelText ,
    required String? Function(String?)? validator,
    Icon? prefixIcon,
    Icon? suffixIcon,
    ValueChanged<String>? onSubmit,
    Function(String)? onChange,
    bool obscureText = false,
    VoidCallback? suffixFun,
    Function()? onTap,
    Function()? onComplete,
    bool autofocus = false,
    bool expands = false ,
    int? maxLines = 1,
    int? minLines,
    String? hintText ,
    bool enabled = true,

}) =>
    TextFormField(
      enabled: enabled,
       maxLines: maxLines,
       minLines: minLines ,
        expands: expands,
        autofocus: autofocus,
        onEditingComplete: onComplete,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border: OutlineInputBorder(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon != null ? IconButton(icon: suffixIcon, onPressed: suffixFun,) : null ,
        ),
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        obscureText: obscureText,
    );

//-------------------------------------------------------------

Widget defaultButton({
  double buttonWidth = double.infinity,
  Color buttonColor = primaryColor,
  Color textColor = Colors.white ,
  required Function() buttonFunction,
  required String buttonText,
}) =>
    Container(
      width: buttonWidth,
      decoration: BoxDecoration(color:buttonColor ),
      child: MaterialButton(

        onPressed: buttonFunction,
        child: Text(
          buttonText.toUpperCase(),
          style: TextStyle(color: textColor),
        ),
      ),
    );



//---------------Toast-----------------------------------------------------------


Future<bool?> makeToast (String mssg) async {
  return  Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor.shade100,
      textColor: Colors.black,
      fontSize: 14.0 );
}

//-------------------------Bottom Sheet gallery/camera------------

  Widget BottomSheetDesign ({
   required Function()? onTapGallery,
    required Function()? onTapCamera,
}){
  return Container(
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    height: 140,
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(height: 3,width: 60,child: Container(color: Colors.white,),),
        ),
        ListTile(
          horizontalTitleGap: 5,
          dense: true,
          title: Text('Gallery',style:TextStyle(color: Colors.white)),
          leading: Icon(IconBroken.Image,color: Colors.white,size: 20,)  ,
          onTap: onTapGallery,),
        ListTile(
          horizontalTitleGap: 5,
          dense: true,
          title: Text('Camera',style:TextStyle(color: Colors.white)),
          leading: Icon(IconBroken.Camera,color: Colors.white,size: 20),
          onTap: onTapCamera,
        ),
      ],
    ),
  ) ;
  }


  // post Item ------------------------------------

Widget postItem(HomeCubit cubit,context, PostModel post, int index){
  return Container(
    width: double.infinity,
    child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (contextProfile){
                        return BlocProvider.value(
                          value: HomeCubit.get(context)..getProfileUser(post.uid.toString()),
                          child: ProfileScreen(),
                        );
                      },
                    ));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(backgroundImage : NetworkImage(post.uImage.toString()),),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(post.uName.toString(),style: Theme.of(context).textTheme.bodyText2,),
                              SizedBox(width: 5.0,),
                              Icon(Icons.check_circle,color: primaryColor,size: 16.0,),
                            ],
                          ),
                          Text(daysBetween(DateTime.parse(post.dateTime.toString())),style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                      Spacer(),
                      IconButton(icon: Icon(Icons.more_horiz), onPressed: () {  },),


                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      post.postText.toString(),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.3),
                      softWrap: true,
                      maxLines: cubit.isExpanded ? null : 3,
                      overflow: TextOverflow.fade,
                    ) ,
                    post.postText!.length>150?
                    Container(
                      height: 30.0,
                      child: TextButton(
                        onPressed: (){
                          cubit.seeMore();
                        },
                        child: cubit.isExpanded ? Text('See Less..') :Text('See More..'),),
                    )
                    : Container()


                  ],
                ),
              ),
              SizedBox(height: 5.0,),

              post.postImage != null ?
              Image(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(post.postImage.toString()),) : Container(),
              SizedBox(height: 5.0,),

              (post.postComments.length == 0 && post.postLikes.length == 0) ? SizedBox()
                  : Padding(
                padding: const EdgeInsets.only(right: 15.0,left: 15.0,top: 5,bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    Expanded(
                      child:
                      (post.postLikes.length == 0) ? SizedBox() :
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (contextLikes){
                              return BlocProvider.value(
                                value: HomeCubit.get(context)..getPostUsersLikes(post.postID),
                                child: PostLikesScreen(),
                              );
                            },
                          ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.recommend,color: primaryColor,size : 18,),
                            SizedBox(width: 2,),
                            Text(post.postLikes.length.toString(),style:Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                    ),


                    Expanded(
                        child:
                        post.postComments.length == 0 ? Text('',textAlign: TextAlign.end) :
                        InkWell(onTap: (){

                          Navigator.push(context, MaterialPageRoute(
                            builder: (contextComments){
                              return BlocProvider.value(
                                value: HomeCubit.get(context)..getPostUsersLikes(post.postID),
                                child: PostWithComments(post,index),
                              );
                            },
                          ));

                        },child: Text('${post.postComments.length.toString()} comments',style:Theme.of(context).textTheme.caption,textAlign: TextAlign.end,))),

                  ],),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SizedBox(height: 1, width: double.infinity, child: Container(color: Colors.grey.withOpacity(0.5),),),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        cubit.likeUnlikePost(post.postID);
                      },
                      child: Column(

                        children: [
                          Icon(post.postLikes.contains(cubit.user!.uid) ? Icons.recommend: Icons.recommend_outlined,
                            size: 20,
                            color: post.postLikes.contains(cubit.user!.uid) ? primaryColor : Colors.black54,
                          ),
                          Text('Like',style:Theme.of(context).textTheme.caption!.copyWith(
                            color: post.postLikes.contains(cubit.user!.uid) ? primaryColor: Colors.black54,
                          )),
                        ],
                      ),

                    ),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (contextComments){
                            return BlocProvider.value(
                              value: HomeCubit.get(context)..getPostUsersLikes(post.postID),
                              child: PostWithComments(post,index),
                            );
                          },
                        ));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.comment_outlined, size: 20,color: Colors.black54,),
                          Text('Comment',style:Theme.of(context).textTheme.caption),
                        ],
                      ),

                    ),
                  ),




                ],
              ),
            ],
          ),
        )
    ),
  );

}


// comment Item -----------------------------------
Widget commentItem(CommentModel comment,context){
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(backgroundImage: NetworkImage(comment.commentUser!.image.toString()),),
      SizedBox(width: 5,),
      Expanded(
        child: Container(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.commentUser!.name.toString()),
                comment.commentUser!.bio == null ? SizedBox() : Text(comment.commentUser!.bio.toString(),style: Theme.of(context).textTheme.caption,),
                Text(comment.dateTime.toString(),style: Theme.of(context).textTheme.caption,),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(comment.commentText.toString(),style: Theme.of(context).textTheme.bodyText1,),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


//friend list item---------------------------------
Widget friendItem (UserModel friendUser,context){
  return  InkWell(
    onTap: (){
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(backgroundImage : NetworkImage(friendUser.image.toString()),),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(friendUser.name.toString(),style: Theme.of(context).textTheme.bodyText2,),
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
