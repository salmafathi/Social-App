abstract class HomeStates {}
class HomeInitialState extends HomeStates {

}

// get user information states
class HomeGetUserInfoLoadingState extends HomeStates {}
class HomeGetUserInfoSuccessState extends HomeStates {}
class HomeGetUserInfoErrorState extends HomeStates {
  final String? errorString ;
  HomeGetUserInfoErrorState(this.errorString);
}

// get user information states
class AddFriendLoadingState extends HomeStates {}
class AddFriendSuccessState extends HomeStates {}
class UnFriendLoadingState extends HomeStates {}
class UnFriendSuccessState extends HomeStates {}

//search
class SearchLoadingState extends HomeStates {}
class  SearchSuccessState extends HomeStates {}

// get profile information states
class HomeGetProfileUserInfoLoadingState extends HomeStates {}
class HomeGetProfileUserInfoSuccessState extends HomeStates {}
class HomeGetProfileUserInfoErrorState extends HomeStates {
  final String? errorString ;
  HomeGetProfileUserInfoErrorState(this.errorString);
}

//bootom Nav bar states
class ChangeBottomNavState extends HomeStates {}

// see More ..
class SeeMoreState extends  HomeStates {}

//NEW post pick image ..
class NewPostPickImageSuccessState extends  HomeStates {}
class NewPostPickImageErrorState extends  HomeStates {}

//new post create new post ---------
class CreateNewPostLoadingState extends  HomeStates {}
class CreateNewPostSuccessState extends  HomeStates {}
class CreateNewPostErrorState extends  HomeStates {}

// new post upload photo
class UploadPhotoPostLoadingState extends  HomeStates {}


//remove post Image------------------------------
class RemovePostImageState extends  HomeStates {}

//Get All posts ------------------------------
class GetPostsLoadingState extends  HomeStates {}
class GetPostsSuccessState extends  HomeStates {}
class GetPostsErrorState extends  HomeStates {}

// get Chat users states
class GetChatUsersInfoLoadingState extends HomeStates {}
class GetChatUsersInfoSuccessState extends HomeStates {}
class GetChatUsersInfoErrorState extends HomeStates {
  final String? errorString ;
  GetChatUsersInfoErrorState(this.errorString);
}

// Send Message ---------------------
class SendMessageSuccessState extends  HomeStates {}
class SendMessageErrorState extends  HomeStates {}

// get Message---------------------
class GetMessageLoadingState extends  HomeStates {}
class GetMessageSuccessState extends  HomeStates {}

// Like post ---------------------
class LikePostsSuccessState extends  HomeStates {}
class LikePostsErrorState extends  HomeStates {}

// unLike post ---------------------
class UnLikePostsSuccessState extends  HomeStates {}
class UnLikePostsErrorState extends  HomeStates {}

//Get Liked people ------------------------------
class GetLikedUsersLoadingState extends  HomeStates {}
class GetLikedUsersSuccessState extends  HomeStates {}
class GetLikedUsersErrorState extends  HomeStates {}

// Post Comment ------------------------------
class GeCommentsLoadingState extends  HomeStates {}
class GeCommentsSuccessState extends  HomeStates {}
class GeCommentsErrorState extends  HomeStates {}

//Get Comments  ------------------------------
class GetAllCommentsLoadingState extends  HomeStates {}
class GetAllCommentsSuccessState extends  HomeStates {}
class GetAllCommentsErrorState extends  HomeStates {}

//pick image
class EditProfilePickPhotoSuccessState extends HomeStates{}
class EditProfilePickPhotoErrorState extends HomeStates{}
class EditProfilePickCoverPhotoSuccessState extends HomeStates{}
class EditProfilePickCoverPhotoErrorState extends HomeStates{}

// update image
class EditProfileUpdatePhotoLoadingState extends HomeStates{}
class EditProfileUpdatePhotoSuccessState extends HomeStates{}
class EditProfileUpdatePhotoErrorState extends HomeStates{}


// update photos List
class EditProfileUpdatePhotosListLoadingState extends HomeStates{}
class EditProfileUpdatePhotosListSuccessState extends HomeStates{}
class EditProfileUpdatePhotosListErrorState extends HomeStates{}


//update Name
class EditProfileUpdateNameLoadingState extends HomeStates{}
class EditProfileUpdateNameSuccessState extends HomeStates{}
class EditProfileUpdateNameErrorState extends HomeStates{}


//update Phone
class EditProfileUpdatePhoneLoadingState extends HomeStates{}
class EditProfileUpdatePhoneSuccessState extends HomeStates{}
class EditProfileUpdatePhoneErrorState extends HomeStates{}




// update Bio
class EditProfileUpdateBioLoadingState extends HomeStates{}
class EditProfileUpdateBioSuccessState extends HomeStates{}
class EditProfileUpdateBioErrorState extends HomeStates{}


class ProfileTabIndexChangedState extends HomeStates{}