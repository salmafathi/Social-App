import 'package:dio/dio.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/shared/components/components.dart';

class DioHelper{
  static late Dio dio ;

  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/',
        receiveDataWhenStatusError: true,
        connectTimeout: 50000 ,
        sendTimeout: 50000,
        validateStatus: (status){return status! < 500;},
      )
    );
  }


  static Future<Response> postData({
    String path = 'send',
    required UserModel senderUser ,
    required String dateTime,
    required String receiverToken,

  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'Authorization' : 'key=AAAAuWv_YGc:APA91bHNtu81SAnQpkf4QxNUk1cyvBvCQRvn5csKHwNycUJ3gcszWmhmaGqeUtsz_ntQJAqMhO3u3mNgoHoL6xdAZIGAs3GY_4rRiajzZeO3JMfUCujQZppM0MG1CgArtfnBTJK7BAEd' ,
    };

    Map<String, dynamic> data = {
      "data": {
        "senderUser":"${senderUser.name}",
        "senderImage":"${senderUser.image}",
        "dateTime": dateTime,
        "click_action":"FLUTTER_NOTIFICATION_CLICK"
      },
      "to": "$receiverToken",
      "notification": {
        "title":"You have received a message from ${senderUser.name}",
        "body":"open Message",
        "sound":"default"

      },
      "android":{
        "priority":"HIGH",
        "notification":{
          "notification_priority":"PRIORITY_MAX",
          "sound":"default",
          "default_sound":true,
          "default_vibrate_timings":true,
          "default_light_settings":true
        }
      }
    };

    return await dio.post(path,data: data);
  }




}