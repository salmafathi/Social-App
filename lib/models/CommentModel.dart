import 'package:social_app/models/UserModel.dart';

class CommentModel {
   UserModel? commentUser ;
   String? commentText ;
   String? dateTime ;
   String? commentID ;

   CommentModel({this.commentUser, this.commentText, this.dateTime, this.commentID});

   CommentModel.fromJson(Map<String,dynamic>? json){
     commentUser = UserModel.fromJson(json!['commentUser']);
     commentText = json['commentText'];
     dateTime = json['dateTime'];
     commentID = json['commentID'];
   }

   Map<String,dynamic> toMap(){
     return {
       'commentText': commentText,
       'dateTime': dateTime,
       'commentID': commentID,
       'commentUser': commentUser!.toMap(),
     };
   }

}