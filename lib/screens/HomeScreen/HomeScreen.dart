import 'package:flutter/material.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/HomeScreen/Notifications/Notifications.dart';
import 'package:social_app/screens/addNewPostScreen/AddNewPostScreen.dart';
import 'package:social_app/screens/profileScreen/ProfileScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'Chat/ChatScreen.dart';
import 'HomeCubit/HomeStates.dart';
import 'Search/Search.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return HomeCubit()..getUserData()..getPosts()..getNotifications();

          },
        child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (BuildContext context, Object? state) {

        },
        builder: (BuildContext context, Object? state){
          var cubit = HomeCubit.get(context);
          var drawerKey = GlobalKey<ScaffoldState>();
          return Scaffold(
            key: drawerKey ,
            appBar: AppBar(
              title: Text(cubit.currentTitle),

                actions:
                cubit.currentBottomNavIndex != 0 ? null :
                [
                IconButton(
                  onPressed: (){
                    navigateTo(context, Notifications());
                  },
                  icon: notificationList.length > 0 ? Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                      child: Icon(IconBroken.Notification),
                    ),
                    new Positioned(
                      right: 8,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: new Text(
                          '${notificationList.length}',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize:12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],) :  Icon(IconBroken.Notification) ,
                  iconSize: 23.0,
                ),
                IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (contextSearch){
                          return BlocProvider.value(
                            value: HomeCubit.get(context),
                            child: Search(),
                          );
                        },
                      ));
                    },
                    icon: Icon(IconBroken.Search),
                    iconSize: 23.0,
                ),
                SizedBox(width: 5.0,)
              ],

            ),

           endDrawer: cubit.user != null ? Drawer(
             child: Container(
               color: primaryColor,
               child: ListView(
                 children: [
                   DrawerHeader(
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                         children: [
                           CircleAvatar(backgroundImage:  NetworkImage(cubit.user!.image.toString()),
                           ),
                           SizedBox(width: 10.0,),
                           Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(cubit.user!.name.toString(),style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),),
                               Text(cubit.user!.email.toString(),style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white60),)
                             ],
                           )
                         ]),


                   ),

                   ListTile(onTap: (){
                     Navigator.push(context, MaterialPageRoute(
                       builder: (contextProfile){
                         return BlocProvider.value(
                           value: HomeCubit.get(context)..getProfileUser(uID.toString()),
                           child: ProfileScreen(),
                         );
                       },
                     ));

                     },
                     title: Text('Profile',style:Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16,color: Colors.white)),
                     leading: Icon(IconBroken.User,color: Colors.white60,size: 20,) ,
                     contentPadding:EdgeInsets.symmetric(horizontal: 25.0) ,
                     horizontalTitleGap: 1.0,
                     minLeadingWidth: 35.0,
                      minVerticalPadding: 1,



                   ),

                   ListTile(onTap: (){
                     signOutFun(context);
                   },
                     title: Text('Log out',style:Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16,color: Colors.white)),
                     leading: Icon(IconBroken.Arrow___Left_2,color: Colors.white60,size: 20,) ,
                     contentPadding:EdgeInsets.symmetric(horizontal: 25.0) ,
                     horizontalTitleGap: 1.0,
                     minLeadingWidth: 35.0,
                     minVerticalPadding: 1,

                   ),
                 ],
               ),
             ),

           ) : Drawer(),

           bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 3.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        IconBroken.Home,
                        color: cubit.currentBottomNavIndex == 0 ? primaryColor : Colors.black54,),
                        onPressed: () {cubit.changeBottomNav(0);},
                    ),
                    IconButton(
                      padding: EdgeInsets.only(right: 25.0),
                      icon: Icon(
                          IconBroken.Chat,
                          color: cubit.currentBottomNavIndex == 1 ? primaryColor : Colors.black54,
                      ),
                      onPressed: () {cubit.changeBottomNav(1);},
                    ),
                    IconButton(
                      padding:EdgeInsets.only(left: 25.0) ,
                      icon: Icon(
                          IconBroken.User1,
                          color: cubit.currentBottomNavIndex == 2 ? primaryColor : Colors.black54,),
                      onPressed: () {cubit.changeBottomNav(2);},
                    ),
                    IconButton(
                      icon: Icon(
                          IconBroken.More_Square,
                          color:  Colors.black54,),
                          onPressed: () {
                            drawerKey.currentState!.openEndDrawer();
                            },
                    ),
                  ]
          ),
            )
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
                mini: true,
                elevation: 5,
                child: const Icon(Icons.add,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (contextAddPost){
                      return BlocProvider.value(
                        value: HomeCubit.get(context),
                        child: AddNewPostScreen(),
                      );
                    },
                  ));
                },
              ),


          body:
            cubit.user != null ?
            cubit.bottomNavScreens[cubit.currentBottomNavIndex]
            : Center(child: CircularProgressIndicator(),)
          );
        },
        ),
    );
  }


}
