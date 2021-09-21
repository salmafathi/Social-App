import 'package:flutter/material.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EditProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var bioController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<HomeCubit,HomeStates>(
    listener: (BuildContext context, Object? state) {
      if (state is EditProfileUpdateBioSuccessState)
        makeToast('Bio Updated Successfully');

      if (state is EditProfileUpdateNameSuccessState)
        makeToast('Name Updated Successfully');

      if (state is EditProfileUpdatePhoneSuccessState)
        makeToast('Phone Updated Successfully');

      if (state is EditProfileUpdateNameLoadingState)
        nameController.text = ' ' ;
      if (state is EditProfileUpdatePhoneLoadingState)
        phoneController.text = ' ' ;
    },
    builder: (BuildContext context, Object? state){

      var cubit = HomeCubit.get(context);
      nameController.text = cubit.user!.name! ;
      phoneController.text = cubit.user!.phone! ;
      var bioKey = GlobalKey<FormState>() ;
      return Scaffold(
        appBar: AppBar(

          title: Text('Edit Profile'),
          backgroundColor: primaryColor,
          titleSpacing: 3.0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Profile Picture',style:Theme.of(context).textTheme.headline6),
                      ),
                      Spacer(),
                      TextButton(onPressed: () {
                        cubit.pickProfileImage();
                      }, child: Text('Edit'),)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(cubit.user!.image.toString()),
                      radius: 50,

                    ),
                  ),
                  SizedBox(height: 1,width: double.infinity,child: Container(color: Colors.grey,),)
                ],
              ),

              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Cover Photo',style:Theme.of(context).textTheme.headline6),
                      ),
                      Spacer(),
                      TextButton(onPressed: () async {
                        cubit.pickCoverImage();
                      }, child: Text('Edit'),)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Container(
                      height: 150.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(cubit.user!.coverImage.toString()),
                            fit: BoxFit.cover
                        ),

                      ),

                    ),
                  ),
                  SizedBox(height: 1,width: double.infinity,child: Container(color: Colors.grey,),)
                ],
              ),

              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Bio',style:Theme.of(context).textTheme.headline6),
                      ),
                      Spacer(),
                      TextButton(onPressed: (){
                       if (bioKey.currentState!.validate())
                         cubit.updateBio(bioController.text) ;
                      }, child: Text('Add'),)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Form(
                      key: bioKey,
                      child: TextFormField(
                          maxLength:20 ,
                          maxLines: null,
                          minLines: null ,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            hintText: cubit.user!.bio == null ? 'Describe yourself...' : cubit.user!.bio,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: OutlineInputBorder(),
                          ),
                          textAlign: TextAlign.start,
                          controller: bioController,
                          keyboardType: TextInputType.multiline,
                          validator: (text){
                            if(text!.isEmpty)
                              return 'bio is empty';
                            return null ;
                          }),
                    ),
                  ),
                  SizedBox(height: 1,width: double.infinity,child: Container(color: Colors.grey,),)
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top:10,bottom: 18),
                    child: Text('Basic Info',style:Theme.of(context).textTheme.headline6),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 18.0,left: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: defaultTextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                labelText: 'name',
                                validator: (name){
                                  if(name!.isEmpty)
                                    return 'Name is empty';
                                  return null ;
                                }),
                          ),

                          TextButton(onPressed: (){cubit.updateName(nameController.text);}, child: Text('Edit'))
                        ],
                      )
                  ),

                  Padding(
                      padding: const EdgeInsets.only(bottom: 18.0,left: 20,),
                      child: Row(
                        children: [
                          Expanded(
                            child: defaultTextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                labelText: 'phone',
                                validator: (phone){
                                  if(phone!.isEmpty)
                                    return 'phone is empty';
                                  return null ;
                                }),
                          ),
                          TextButton(onPressed: (){cubit.updatePhone(phoneController.text);}, child: Text('Edit'))

                        ],
                      )
                  ),

                  SizedBox(height: 1,width: double.infinity,child: Container(color: Colors.grey,),)
                ],
              ),
            ],
          ),
        ),
      ) ;
    },
       );
  }



}
