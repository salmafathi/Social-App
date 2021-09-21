import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/Edit_profile/EditProfile.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HomeCubit,HomeStates>(
      listener: (BuildContext context, Object? state) {
        if (state is EditProfileUpdatePhotoSuccessState)
          makeToast('Photo Updated Successfully');

        if(state is EditProfileUpdatePhotoLoadingState)
          makeToast('Uploading...');
      },
      builder: (BuildContext context, Object? state){
        var cubit = HomeCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
            appBar:
            cubit.profileUser == null ? AppBar() :
            AppBar(
              title: Text('Profile'),
              actions: [
               cubit.profileUser!.uid == uID ? IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                       builder: (contextEdit){
                       return BlocProvider.value(
                        value: HomeCubit.get(context),
                        child: EditProfile(),
                      );
                    },
                  ));
                  }, icon: Icon(IconBroken.Edit_Square)) : SizedBox(),
              ],
              backgroundColor: primaryColor,
              elevation: 50.0,
              titleSpacing: 3.0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
            ),
            body: cubit.profileUser != null ?

               SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      //cover photo
                      Container(
                        height: 120,
                        decoration: BoxDecoration(image: DecorationImage(
                            image: cubit.coverImage == null ?
                            NetworkImage(cubit.profileUser!.coverImage.toString())
                            :  Image.file(cubit.coverImage!).image,
                            fit: BoxFit.cover)),

                      ),
                      cubit.profileUser!.uid == uID ?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor:  Colors.grey.shade300,
                            child: IconButton(onPressed: (){
                          scaffoldKey.currentState!.showBottomSheet((context) =>
                              BottomSheetDesign(
                                  onTapGallery: () {
                                   cubit.pickCoverImage().then((value) =>  Navigator.pop(context));
                                  },
                                  onTapCamera: () {
                                    cubit.pickCoverCameraPhoto().then((value) =>  Navigator.pop(context));
                              })
                          );
                        }, icon: Icon(IconBroken.Camera,size: 20,),)),
                      ) : SizedBox(),
                      //profile photo
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                backgroundImage:cubit.profileimage == null ? NetworkImage(cubit.profileUser!.image.toString()): Image.file(cubit.profileimage!).image,),
                            ),
                          ),
                        ),
                      ),

                      cubit.profileUser!.uid == uID ?
                      Padding(
                        padding: const EdgeInsets.only(top:130,left: 90),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                                backgroundColor:  Colors.grey.shade300,
                                radius: 15,
                                child: IconButton(onPressed: (){
                              scaffoldKey.currentState!.showBottomSheet((context) =>
                              BottomSheetDesign(
                                  onTapGallery: ()  {
                                    cubit.pickProfileImage().then((value){
                                      Navigator.pop(context);
                                    });

                              }, onTapCamera: () {
                                   cubit.pickProfileCameraPhoto().then((value) =>  Navigator.pop(context));
                              })
                              );

                            }, icon: Icon(IconBroken.Camera,size: 15,)))),
                      ) : SizedBox(),
                    ],
                  ),

                  SizedBox(height: 10,),
                  //User Name
                  Text( cubit.profileUser!.name.toString()  ,style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 22.0),),

                  //User bio
                  Text(cubit.profileUser!.bio == null? ' ':cubit.profileUser!.bio.toString(),style: Theme.of(context).textTheme.caption,),

                  //Add Friend
                  cubit.profileUser!.uid == uID ? SizedBox() :
                  cubit.isFriend?
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 5.0),
                         child: OutlinedButton(onPressed: (){
                           cubit.unFriend(cubit.profileUser!);
                         }, child: Text('Unfriend'),),
                       )
                   :  Padding(
                     padding: const EdgeInsets.symmetric(vertical: 5.0),
                     child: OutlinedButton(onPressed: (){
                     cubit.addFriend(cubit.profileUser!);
                     }, child: Text('Add Freind'),),
                     ),





                  //DashBoard
                  Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.rectangle,
                              boxShadow: [BoxShadow(color: Colors.grey,spreadRadius: 0.1)]

                          ),
                          child: Row(

                            //Dash Board Elements ...
                            children: [
                              Expanded(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Posts', style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
                                  SizedBox(height: 3,),
                                  Text(cubit.profileUser!.uPosts.isEmpty? '0' : cubit.profileUser!.uPosts.length.toString(), style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),)
                                ],)),
                              SizedBox(width: 0.5, child: Container(color: Colors.grey.shade300,),),
                              Expanded(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Photos', style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
                                  SizedBox(height: 3,),
                                  Text(cubit.profileUser!.userPhotos == null ? '0' : cubit.profileUser!.userPhotos!.length.toString(), style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),)
                                ],)),
                              SizedBox(width: 0.5, child: Container(color: Colors.grey.shade300,),),
                              Expanded(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Freinds', style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),),
                                  SizedBox(height: 3,),
                                  Text(cubit.profileUser!.friends.isEmpty? '0' : cubit.profileUser!.friends.length.toString(), style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),)
                                ],)),
                            ],

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: DefaultTabController(
                            length: 3,
                            child: TabBar(
                              labelPadding: EdgeInsets.symmetric(vertical: 5),
                              physics: BouncingScrollPhysics(),
                              labelColor: primaryColor,
                              unselectedLabelColor: Colors.grey,
                              onTap: (index){
                                cubit.changeTabView(index);
                              },
                              tabs: [Text('Posts'),Text('Photos'),Text('Friends')],),
                          ),
                        ),

                        cubit.currentIndex == 1 ?
                           cubit.profileUser!.userPhotos == null ? Container(height: 250,child: Center(child: Text('No photos yet'),)) : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                          child: photos(cubit.profileUser!.userPhotos),
                        )
                        : cubit.currentIndex == 2 ?
                           cubit.profileUser!.friends.isEmpty ? Container(height: 250,child: Center(child: Text('No Friends yet'),)) : Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index) => friendItem(cubit.profileUser!.friends[index],context),
                                separatorBuilder: (context,index) =>Container(height: 1.0, width: double.infinity,color: Colors.grey.shade300,),
                                itemCount: cubit.profileUser!.friends.length),
                        )
                        :
                        cubit.userProfilePosts.isEmpty ? Center(child: Text('No posts yet'),) : Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: ListView.separated(

                            shrinkWrap: true,
                            itemBuilder: (context, index) => postItem(cubit,context,cubit.userProfilePosts[index],index),
                            itemCount: cubit.userProfilePosts.length,
                            physics:NeverScrollableScrollPhysics (),
                            separatorBuilder: (BuildContext context, int index)=> SizedBox(height: 5.0,),

                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            )
                :Center(child: CircularProgressIndicator(),)
        );
      }
    );
  }


  Widget photos(List<String>? images){
     return  images != null ? GridView.count(
       shrinkWrap: true,
       physics: NeverScrollableScrollPhysics(),
       mainAxisSpacing: 4.0,
       crossAxisSpacing: 4.0,
       padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
       crossAxisCount: 3,
       children: List.generate(images.length, (index) => Image(
          fit: BoxFit.cover,
          image: NetworkImage(images[index])))
      ,

    ) : Container();
  }



}
