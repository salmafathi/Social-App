import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';


class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
      return BlocConsumer<HomeCubit,HomeStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextFormField(
                      autofocus: true,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      labelText: 'Search',
                      validator: (text){
                        if(text!.isEmpty)
                        { return 'write some text to search about !';}
                        return null;
                      },
                      prefixIcon: Icon(Icons.search),
                      onSubmit: (text){

                      },
                      onChange: (text){
                        cubit.search(text);
                      }

                    ),

                  //  SizedBox(height: 10.0,),

                   // LinearProgressIndicator(),
                    SizedBox(height: 20.0,),
                    Expanded(
                      child:
                      cubit.searchResult.isNotEmpty ?
                      ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) =>postItem(cubit, context, cubit.searchResult[index], index),
                        itemCount:cubit.searchResult.length,
                        separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 15.0,),

                      )
                      :
                      state is SearchLoadingState ?
                        Center(child: CircularProgressIndicator(),)
                        : Center(child: Text('No Search Result.'),),
                    ),


                  ],
                ),
              ),
            ),
          ) ;
        },
      );
     }
  }

