import 'package:social_app/models/PostModel.dart';

class MessageModel {
  String? senderID ;
  String? receiverID ;
  String? dateTime ;
  String?  text;

  MessageModel({required this.senderID,required this.receiverID,required this.dateTime, required this.text});

  MessageModel.fromJson(Map<String,dynamic>? json){
    senderID = json!['senderID'];
    receiverID = json['receiverID'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String,dynamic> toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = senderID ;
    data['receiverID'] = receiverID ;
    data['dateTime'] = dateTime ;
    data['text'] = text ;
    return data ;
  }
}