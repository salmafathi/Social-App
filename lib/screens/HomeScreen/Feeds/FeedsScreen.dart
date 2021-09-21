import 'package:flutter/material.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HomeCubit,HomeStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, Object? state)
      {
        var cubit = HomeCubit.get(context);

        return
       //   cubit.allPosts.isNotEmpty?
          RefreshIndicator(
            onRefresh:(){cubit.getPosts() ; return cubit.getUserData();},
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => postItem(cubit,context,cubit.allPosts[index],index),
              itemCount: cubit.allPosts.length,
              physics: BouncingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index)=> SizedBox(height: 5.0,),

        ),
          );

        //  : Center(child: CircularProgressIndicator(),);
        },
    );
  }


}
