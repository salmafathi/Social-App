import 'package:flutter/cupertino.dart';
import 'package:social_app/models/CommentModel.dart';
import 'package:social_app/models/MessageModel.dart';
import 'package:social_app/models/NotificationModel.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/HomeScreen/Chat/ChatScreen.dart';
import 'package:social_app/screens/HomeScreen/Feeds/FeedsScreen.dart';
import 'package:social_app/screens/HomeScreen/Settings/Settings.dart';
import 'package:social_app/screens/HomeScreen/Users/UsersScreen.dart';
import 'package:social_app/shared/Network/remote/dio_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_app/shared/components/constants.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  //get user data
  UserModel? user ;
  Future<void> getUserData()async {
    emit(HomeGetUserInfoLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(uID).get()
    .then((value){
      user = UserModel.fromJson(value.data());
      emit(HomeGetUserInfoSuccessState());
    })
    .onError((error,stack){
      print(stack.toString());
      print(error);
      emit(HomeGetUserInfoErrorState(error.toString()));
    })
    ;
  }

  //get profile user
  UserModel? profileUser ;
  List<PostModel> userProfilePosts = [];
  Future<void> getProfileUser(String userID)async {
    userProfilePosts.clear();
    emit(HomeGetProfileUserInfoLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(userID).get()
        .then((value){
      profileUser = UserModel.fromJson(value.data());

      allPosts.forEach((element) {
        if(element.uid == userID)
          userProfilePosts.add(element);
      });

      friendOrUnfriend(profileUser);
      emit(HomeGetProfileUserInfoSuccessState());
    })
        .onError((error,stack){
          emit(HomeGetProfileUserInfoErrorState(error.toString()));
      print(stack.toString());
      print(error);
    })
    ;
  }

  bool isFriend = false ;
  friendOrUnfriend (UserModel? model){
      user!.friends.forEach((element) {
        if(element.uid == model!.uid)
          isFriend = true ;
        else
          isFriend = false ;
      }) ;
  }

  List<UserModel> userFriends = [] ;
  Future<void> addFriend (UserModel newFriend) async {
    emit(AddFriendLoadingState());
    userFriends =  user!.friends;
    userFriends.add(newFriend);

    FirebaseFirestore.instance.collection('users').doc(uID).update({'friends':userFriends.map((e) => e.toMap()).toList()})
        .then((value)  {
          isFriend = true ;
          // user!.friends.add(newFriend);
          // friendOrUnfriend(newFriend);
          emit(AddFriendSuccessState());
        })
        .catchError((error){print(error.toString());});
  }

  void unFriend(UserModel friend) {
    emit(UnFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .update({'friends':FieldValue.arrayRemove([friend.toMap()])})
        .then((value) {
        isFriend = false ;
         emit(UnFriendSuccessState());
    })
    .onError((stack ,error){
      print(error);
      print(stack);
    })
    ;
  }


  //Search .......................
  List<PostModel> searchResult = [] ;
  Future<void> search (String text) async {
    emit(SearchLoadingState());
    searchResult.clear();

    allPosts.forEach((element) {
        if(element.postText!.contains(text))
          searchResult.add(element);
      });

    emit(SearchSuccessState());
  }


  //bottom navigation
  List<Widget> bottomNavScreens = [
    FeedsScreen(),
    ChatScreen(),
    FriendsScreen(),
  ] ;
  List<String> titles = ['News Feed','Chats','Friends'];
  String currentTitle = 'News Feed' ;
  int currentBottomNavIndex = 0 ;
  void changeBottomNav(int index){
    if(index == 1)
      getChatUsers();
    currentBottomNavIndex = index ;
    currentTitle = titles[index];
    emit(ChangeBottomNavState());
  }


  //seemore paragraph task


  bool isExpanded = false;
  void seeMore (){
       isExpanded = ! isExpanded ;
       emit(SeeMoreState());
  }


//----------Pick image New Post -------------------------
  var picker = ImagePicker();
  File? postImage;

  Future<void> pickPostImage()async {
    if(postImage != null)
      postImage = null ;
    await picker.pickImage(source: ImageSource.gallery)
        .then((value) {
      postImage = File(value!.path);
     // uploadProfilePhoto();
      emit(NewPostPickImageSuccessState());
    })
        .catchError((error){
      emit(NewPostPickImageErrorState());
    })

    ;
  }

  Future<void> pickPostCameraPhoto()async {
    if(postImage != null)
      postImage = null ;
    await picker.pickImage(source: ImageSource.camera,imageQuality: 80)
        .then((value){
      postImage = File(value!.path);

      emit(NewPostPickImageSuccessState());
    })
        .catchError((error){
      print('error in pick camera photo : ${error.toString()}');
      emit(NewPostPickImageErrorState());
    });
  }



//----------Create New Post ------------------------------

  void uploadPostImage({
  required String dataTime ,
    String? postText ,

}){
    emit(UploadPhotoPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value){
          print('photo uploaded successfully');
            value.ref.getDownloadURL().then((value){
                createNewPost(
                  dateTime: dataTime,
                  postImage: value,
                  postText: postText ,
                );

      }).catchError((error){
        print('errrrrrrror in get post photo uri $error');
      });
    })
        .catchError((error){
      emit(CreateNewPostErrorState());
      print('errrrrrrror in create new post $error');
    })
    ;
  }
  

  void createNewPost ({
    String? postImage,
    String? postText ,
    required String dateTime ,
}){
    emit(CreateNewPostLoadingState());
    PostModel post = PostModel(
      uid: user!.uid ,
      uName: user!.name,
      uImage : user!.image ,
      postImage : postImage ,
      postText: postText ,
      dateTime : dateTime ,
      postID: null,
      postLikes : [] ,
      postComments : [] ,
    );
    String postID = '' ;
    FirebaseFirestore.instance.collection('posts').add(post.toMap())
        .then((value) {
          postID = value.id ;
          FirebaseFirestore.instance.collection('posts').doc(value.id).update({'postID':value.id})
             .then((value){
               post.postID = postID ;
               addPostToUser(post);
               allPosts.add(post);
         });

          emit(CreateNewPostSuccessState());
    })
        .catchError((error){
          print('error in creating post $error');
          emit(CreateNewPostErrorState());
    });


  }

  void addPostToUser (PostModel newPost){
    List<PostModel>? userPosts;
    userPosts =  user!.uPosts;
    userPosts.add(newPost);

    FirebaseFirestore.instance.collection('users').doc(uID).update({'uPosts':userPosts.map((e) => e.toMap()).toList()})
    .then((value) => user!.uPosts.add(newPost))
    .catchError((error){print(error.toString());});
  }

  void removePostImage (){
    postImage = null ;
    emit(RemovePostImageState());
  }

//get All posts to Feeds -------------------------------------
  List<PostModel> allPosts = []  ;
Future<void> getPosts()async {
    emit(GetPostsLoadingState());
    allPosts.clear() ;
    await FirebaseFirestore.instance.collection('posts').orderBy('dateTime',descending: true).get()
    .then((value) {
      emit(GetPostsSuccessState());
      value.docs.forEach((element) {
        allPosts.add(PostModel.fromJson(element.data()));
      });


    })
    .catchError((error){
      print(error.toString());
      emit(GetPostsErrorState());
    })
    ;


}


//Like / unlike a post --------------------------------------------------------------
  List<String> postLikesUID = []  ;
Future<void> getPostLikes (String? postID) async{
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(postID!)
      .get().then((value) {
          postLikesUID = List<String>.from(value.data()!['postLikes']);
          print('this post likes are : $postLikesUID');
  });
}

void likeUnlikePost (String? postID){
  getPostLikes(postID).then((value) {
    postLikesUID.contains(user!.uid) ? unlike(postID!) : like(postID!);
  });
}

void like (String postID){
  FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .update({'postLikes':FieldValue.arrayUnion([user!.uid])})
      .then((value) {


        allPosts.forEach((element) {
          if(element.postID == postID)
            element.postLikes.add(user!.uid.toString());
        });

        user!.uPosts.forEach((element) {
          if(element.postID == postID)
            element.postLikes.add(user!.uid.toString());
        });
      //getPosts();
    emit(LikePostsSuccessState());
  })
      .catchError((error){
    print(error.toString());
    emit(LikePostsErrorState());
  });
}

void unlike (String postID){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postLikes':FieldValue.arrayRemove([user!.uid])})

        .then((value) {
        // getPostLikes(postID);
      allPosts.forEach((element) {
        if(element.postID == postID)
          element.postLikes.remove(user!.uid.toString());
      });

      user!.uPosts.forEach((element) {
        if(element.postID == postID)
          element.postLikes.remove(user!.uid.toString());
      });
        //  getPosts();
      emit(UnLikePostsSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(UnLikePostsErrorState());
    });
  }


// get users who Likes this post -------------------------------------
  List<UserModel>? usersWhoLikes =[] ;
  Future<void> getPostUsersLikes (String? postID) async{
    usersWhoLikes!.clear();
    emit(GetLikedUsersLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID!)
        .get().then((value) {
          List<String>.from(value.data()!['postLikes']).forEach((element) {

            FirebaseFirestore.instance
                .collection('users')
                .doc(element)
                .get().then((value)  {
                  usersWhoLikes!.add(UserModel.fromJson(value.data()));
                  emit(GetLikedUsersSuccessState());
                });
          });


    });
  }


// add comment ---------------------------------------------------
  void addComment (String postID,CommentModel comment){
    emit(GeCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postComments':FieldValue.arrayUnion([comment.toMap()])})

        .then((value) {
      allPosts.forEach((element) {
        if(element.postID == postID)
          element.postComments.add(comment);
      });
      emit(GeCommentsSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(GeCommentsErrorState());
    });
  }

//get Chat List
  List<UserModel> chatUsers = [] ;
  Future<void> getChatUsers() async {
    emit(GetChatUsersInfoLoadingState());
    chatUsers.clear() ;
    await FirebaseFirestore.instance.collection('users').get()
        .then((value) {
            value.docs.forEach((element) {
             if( element.id != user!.uid.toString())
                 chatUsers.add(UserModel.fromJson(element.data()));
             });

            emit(GetChatUsersInfoSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(GetChatUsersInfoErrorState(error.toString()));
    })
    ;
  }

// send Message...............
void sendMessage ({
  required String receiverID ,
  required String dateTime ,
  required String text ,
  required UserModel receiverUser ,
}){

    MessageModel message = MessageModel(
      dateTime: dateTime,
      receiverID: receiverID,
      senderID: user!.uid,
      text: text
    );
    ////////////// sender chat :
    FirebaseFirestore.instance
    .collection('users')
    .doc(uID)
    .collection('chats')
    .doc(receiverID)
    .collection('messages')
    .add(message.toMap())
    .then((value){
      DioHelper.postData(
          senderUser: user!,
          receiverToken: receiverUser.uToken.toString(),
          dateTime: dateTime)
          .then((value) => saveNotifications(NotificationModel(senderName: user!.name, senderImage: user!.image, dateTime: dateTime)));
      emit(SendMessageSuccessState());
    })
    .catchError((error){
      print(error.toString());
      emit(SendMessageErrorState());
    });

    ////////////// receiver chat:

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverID)
        .collection('chats')
        .doc(uID)
        .collection('messages')
        .add(message.toMap())
        .then((value){
      emit(SendMessageSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(SendMessageErrorState());
    });


}

// get Messages .........
  List<MessageModel> messages = [] ;
  void getMessages ({required String receiverID}){
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages.clear();
          event.docs.forEach((element) {
            messages.add(MessageModel.fromJson(element.data()));
          });

          emit(GetMessageSuccessState());
    });
  }


// save Notifications.......
  void saveNotifications (NotificationModel notification){
    FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toMap());
  }

  //get notifications.........
  Future<void> getNotifications() async {
    notificationList.clear();
    await FirebaseFirestore.instance.collection('notifications').orderBy('dateTime',descending: true).get()
        .then((value) {
        value.docs.forEach((element) {
          notificationList.add(NotificationModel.fromJson(element.data()));
      });

    });
  }
//-----------------------------------------------------------------------------
//---------------- Profile / Edit Profile Cubit -------------------------------


//------------update profile photo ----------------------------------
  File? profileimage;

  Future<void> pickProfileImage()async {
    await picker.pickImage(source: ImageSource.gallery)
        .then((value) {
      profileimage = File(value!.path);
      uploadProfilePhoto();
      emit(EditProfilePickPhotoSuccessState());
    })
        .catchError((error){
      emit(EditProfilePickPhotoErrorState());
    })

    ;
  }

  Future<void> pickProfileCameraPhoto()async {
    await picker.pickImage(source: ImageSource.camera)
        .then((value){
      profileimage = File(value!.path);
      uploadProfilePhoto();
      emit(EditProfilePickPhotoSuccessState());
    })
        .catchError((error){
      emit(EditProfilePickPhotoErrorState());
    });
  }

  void uploadProfilePhoto (){
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileimage!.path).pathSegments.last}')
        .putFile(profileimage!)
        .then((value){
      value.ref.getDownloadURL().then((value){
        updateProfilePhoto(value);
      }).catchError((error){
        print('errrrrrrror in get uri $error');
      });
    })
        .catchError((error){
      print('errrrrrrror in uploading $error');
    })
    ;
  }

  void updateProfilePhoto (String newPhoto){
    emit(EditProfileUpdatePhotoLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).update({'image': newPhoto})
        .then((value){
      emit(EditProfileUpdatePhotoSuccessState());
      addPhotoToUserPhotos(newPhoto);
    })
        .catchError((error){
      print('errrrrrrror in update $error');
      emit(EditProfileUpdatePhotoErrorState());
    })
    ;
  }

  void addPhotoToUserPhotos(String newPhotoUrl){
    List<String> photos = new List.empty(growable: true);
    photos =  (user!.userPhotos != null ?  user!.userPhotos : [])!;
    photos.add(newPhotoUrl);

    FirebaseFirestore.instance.collection('users').doc(uID).update({'userPhotos':photos})
        .then((value) {
      emit(EditProfileUpdatePhotosListSuccessState());
      getUserData();
    })
        .catchError((error){
      print(error.toString());
      emit(EditProfileUpdatePhotosListErrorState());
    })
    ;

  }

//------------update cover photo ----------------------------------

  File? coverImage;

  Future<void> pickCoverImage()async {
    await picker.pickImage(source: ImageSource.gallery)
        .then((value) {
      coverImage = File(value!.path);
      uploadCoverPhoto();
      emit(EditProfilePickPhotoSuccessState());
    })
        .catchError((error){
      print(error.toString());
      emit(EditProfilePickPhotoErrorState());
    })

    ;
  }

  Future<void> pickCoverCameraPhoto()async {
    await picker.pickImage(source: ImageSource.camera)
        .then((value){
      coverImage = File(value!.path);
      uploadCoverPhoto();
      emit(EditProfilePickPhotoSuccessState());
    })
        .catchError((error){
      emit(EditProfilePickPhotoErrorState());
    });
  }

  void uploadCoverPhoto (){
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value){
      value.ref.getDownloadURL().then((value){
        updateCoverPhoto(value);
        addPhotoToUserPhotos(value);
        getUserData();

      }).catchError((error){
        print('errrrrrrror in get uri $error');
      });
    })
        .catchError((error){
      print('errrrrrrror in uploading $error');
    })
    ;
  }

  void updateCoverPhoto (String newPhoto){
    emit(EditProfileUpdatePhotoLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).update({'coverImage': newPhoto})
        .then((value){
      emit(EditProfileUpdatePhotoSuccessState());
      //  getUserData();
    })
        .catchError((error){
      print('errrrrrrror in update $error');
      emit(EditProfileUpdatePhotoErrorState());
    })
    ;
  }

  void updateName (String newName){
    emit(EditProfileUpdateNameLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).update({'name': newName})
        .then((value){
      emit(EditProfileUpdateNameSuccessState());
      getUserData();
    })
        .catchError((error){
      emit(EditProfileUpdateNameErrorState());
    })
    ;
  }

// change Phone ..................................
  void updatePhone (String newPhone){
    emit(EditProfileUpdatePhoneLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).update({'phone': newPhone})
        .then((value){
      emit(EditProfileUpdatePhoneSuccessState());
      getUserData();
    })
        .catchError((error){
      emit(EditProfileUpdatePhoneErrorState());
    })
    ;
  }

//-------------------Update Bio ---------------------
  void updateBio (String newBio){
    emit(EditProfileUpdateBioLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).update({'bio': newBio})
        .then((value){
      emit(EditProfileUpdateBioSuccessState());
      getUserData();
    })
        .catchError((error){
      emit(EditProfileUpdateBioErrorState());
    })
    ;
  }

//--------------profile tab view--------------------------

  int currentIndex = 0 ;
  void changeTabView(int index){
    currentIndex = index ;
    emit(ProfileTabIndexChangedState());
  }




}
