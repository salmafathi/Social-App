import 'package:flutter/material.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AddNewPostScreen extends StatelessWidget {
  var addPostController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool postButtonEnable = false ;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
    listener: (BuildContext context, Object? state) {
      if(state is CreateNewPostSuccessState)
        Navigator.pop(context);
    },
     builder : (BuildContext context, Object? state){
      var cubit = HomeCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          leading: IconButton(icon :Icon(Icons.close), onPressed: () {
            Navigator.pop(context);
          } , ),
          actions: [
            TextButton(
                onPressed: (){
                  var now = DateTime.now();
                  if (formKey.currentState!.validate()) {
                   if(cubit.postImage == null)
                     {
                       cubit.createNewPost(dateTime: now.toString(),postText: addPostController.text);
                     }
                   else
                     {
                       cubit.uploadPostImage(dataTime:  now.toString(),postText: addPostController.text);
                     }
                  }
                }, child: Text('Post',style: Theme.of(context).textTheme.headline6!.copyWith(color: primaryColor,fontSize: 18),))
          ],
        ),
        body:
        state is CreateNewPostLoadingState ? Center(child: CircularProgressIndicator(),) :
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(backgroundImage : NetworkImage(cubit.user!.image.toString()),),
                    SizedBox(width: 10.0,),
                    Row(
                      children: [
                        Text(cubit.user!.name.toString(),style: Theme.of(context).textTheme.bodyText2,),
                        SizedBox(width: 5.0,),
                        Icon(Icons.check_circle,color: primaryColor,size: 16.0,),
                      ],
                    ),


                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 20.0),
                  child: Column(
                    children: [
                      TextFormField(
                          maxLength:400 ,
                          maxLines: null,
                          minLines: null ,
                          //  expands: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'What do you want to say?',
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: OutlineInputBorder(),
                          ),
                          textAlign: TextAlign.start,
                          controller: addPostController,
                          keyboardType: TextInputType.multiline,
                          validator: (text){
                            if(text!.isEmpty)
                              return 'post is empty';
                            return null ;
                          }),
                      cubit.postImage ==null ? SizedBox():

                      Stack(
                        children: [
                          Image(image: Image.file(cubit.postImage!).image,fit: BoxFit.cover,height: 200,width: double.infinity,),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            child: IconButton(onPressed: () {
                              cubit.removePostImage();
                            }, icon: Icon(IconBroken.Delete),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(icon: Icon(Icons.add_photo_alternate_outlined,color: primaryColor,), onPressed: () { cubit.pickPostImage(); },),
                      IconButton(icon: Icon(Icons.camera_alt_outlined,color: primaryColor,), onPressed: () { cubit.pickPostCameraPhoto(); },),

                    ],
                  ),
                ),
              )


            ],
          ),
        ),

      ) ;
      }
    );
  }
}
