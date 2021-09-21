import 'package:flutter/material.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PostLikesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, Object? state)  {

        return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('People who liked'),
        ),

        body: state is GetLikedUsersLoadingState ? Center(child:CircularProgressIndicator()):
        Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: ListView.separated(
              itemBuilder: (context,index)=>whoLikesPostItemBuilder(cubit.usersWhoLikes![index],context),
              separatorBuilder: (context,index)=>Container(width: double.infinity,height: 1, color:Colors.grey.shade200,),
              itemCount: (cubit.usersWhoLikes!.length),

      ),
        ),
      );
        },
    );}

  Widget whoLikesPostItemBuilder (UserModel likerUser,context){
    return InkWell(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundImage: NetworkImage(likerUser.image.toString()),),
            SizedBox(width: 15,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(likerUser.name.toString(),style: Theme.of(context).textTheme.bodyText2!,),

               likerUser.bio == null ? SizedBox() :
                Text(likerUser.bio.toString(),style: Theme.of(context).textTheme.caption!,)
              ],
            )
          ],
        ),
      ),
    );
  }


}
