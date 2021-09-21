import 'package:social_app/models/CommentModel.dart';

class PostModel {
  String? uid ;
  String? uName ;
  String? uImage ;
  String? postImage;
  String? postText ;
  String? dateTime ;
  String? postID ;
  List<String> postLikes = [];
  List<CommentModel> postComments = [];



  PostModel({this.postID,this.uid, this.uName, this.uImage, this.postImage, this.postText, this.dateTime,required this.postLikes, required this.postComments});

  PostModel.fromJson(Map<String,dynamic>? json){
    uid = json!['id'];
    uName = json['uName'];
    uImage = json['uImage'];
    postImage = json['postImage'];
    postText = json['postText'];
    dateTime = json['dateTime'];
    postID = json['postID'];
    postLikes = (json['postLikes'] != null ? List<String>.from(json['postLikes']) : null)!;

    print('comments : ${json['postComments']}');

    json['postComments'].forEach((v) {
      if( v != null)
        postComments.add(CommentModel.fromJson(v));
    });
  }

  Map<String,dynamic> toMap(){
    return {
      'id':uid ,
      'uName':uName ,
      'uImage':uImage ,
      'postImage':postImage ,
      'postText':postText ,
      'dateTime':dateTime,
      'postID':postID,
      'postLikes': postLikes.map((e) => e.toString()).toList(),
      'postComments': postComments.map((e) => e.toMap()).toList() ,
    };
  }
}