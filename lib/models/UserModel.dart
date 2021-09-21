import 'package:social_app/models/PostModel.dart';

class UserModel {
  String? uid ;
  String? name ;
  String? email ;
  String?  phone;
  String? image ;
  String? coverImage ;
  String? bio ;
  List<String>? userPhotos ;
  List<UserModel> friends = [] ;
  List<PostModel> uPosts =[];

  late bool isEmailVerified ;

  String? uToken ;

  UserModel({this.uToken,required this.uPosts,required this.friends,this.userPhotos,this.coverImage,this.bio,this.uid, this.name, this.email, this.phone, this.image,required this.isEmailVerified});

  UserModel.fromJson(Map<String,dynamic>? json){
    uid = json!['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    userPhotos = json['userPhotos'] != null ? List<String>.from(json['userPhotos']) : null ;
   // friends = json['friends'] != null ? List<String>.from(json['friends']) : null ;

    json['friends'].forEach((v)
    {
      if( v != null)
        friends.add(UserModel.fromJson(v));
    })  ;
    print(json['uPosts']);
    json['uPosts'].forEach((v)
    {
      if( v != null)
        uPosts.add(PostModel.fromJson(v));
    })  ;

    uToken = json['uToken'] != null ? json['uToken'] : null ;

  }

  Map<String,dynamic> toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = uid ;
    data['name'] = name ;
    data['email'] = email ;
    data['phone'] = phone ;
    data['image'] = image ;
    data['isEmailVerified'] = isEmailVerified ;
    data['coverImage'] = coverImage ;
    data['bio'] = bio ;
    data['userPhotos'] = userPhotos != null ? userPhotos!.map((e) => e.toString()).toList() : null ;
    data['friends'] = friends.map((e) => e.toMap()).toList();
    data['uPosts'] = uPosts.map((e) => e.toMap()) .toList()  ;
    data['uToken'] = uToken != null ? uToken : null ;
    return data ;
  }
}