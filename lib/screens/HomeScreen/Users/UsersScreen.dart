import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
    listener: (BuildContext context, Object? state) {},
    builder : (BuildContext context, Object? state){
      var cubit = HomeCubit.get(context);
      return
        cubit.user!.friends.isNotEmpty  ?
        ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index) => friendItem(cubit.user!.friends[index],context),
            separatorBuilder: (context,index) =>Container(height: 1.0, width: double.infinity,color: Colors.grey.shade300,),
            itemCount: cubit.user!.friends.length)

            :  Center(child: Text('No Friends'),);
    }
    );
  }
}
