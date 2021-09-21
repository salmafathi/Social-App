import 'package:flutter/material.dart';
import 'package:social_app/models/NotificationModel.dart';
import 'package:social_app/models/UserModel.dart';
import 'package:social_app/screens/Edit_profile/EditProfile.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeCubit.dart';
import 'package:social_app/screens/HomeScreen/HomeCubit/HomeStates.dart';
import 'package:social_app/screens/HomeScreen/HomeScreen.dart';
import 'package:social_app/screens/LoginScreen/LoginScreen.dart';
import 'package:social_app/screens/onboarding/onBoardingScreen.dart';
import 'package:social_app/shared/Network/local/cache_helper.dart';
import 'package:social_app/shared/Network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/blocobserver.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();


  // handle firebase Messaging FCM ............
  FirebaseMessaging.onMessage.listen((event) {
    NotificationModel model = NotificationModel(senderName: event.data['senderUser'], senderImage: event.data['senderImage'], dateTime: event.data['dateTime']);
    notificationList.add(model);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    NotificationModel model = NotificationModel(senderName: event.data['senderUser'], senderImage: event.data['senderImage'], dateTime: event.data['dateTime']);
    notificationList.add(model);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  //get data  from shared preference
  await CachHelper.init() ;
  Widget startScreen ;
  bool? onBoard = CachHelper.getDataFromSharedPreference(key: 'onboard');
  uID = CachHelper.getDataFromSharedPreference(key: 'uID');

  if(onBoard != null)
  {
    if(uID==null)
    {
      startScreen = LoginScreen();
    }
    else{
      startScreen = HomeScreen();
    }
  }
  else {startScreen = OnBoardingScreen();}

  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  late final Widget startWidgetScreen ;
  MyApp(this.startWidgetScreen);
  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(providers: [
    //    BlocProvider(create: (BuildContext context) {
    //      return HomeCubit();
    //    })
    //  ],
    //  child: BlocConsumer<HomeCubit,HomeStates>(
    //    listener: (BuildContext context, state) {  },
    //    builder: (BuildContext context, Object? state) {
    //     return MaterialApp(
    //       title: 'Flutter Demo',
    //       debugShowCheckedModeBanner: false,
    //       theme: lightTheme,
    //       darkTheme: darkTheme,
    //       //  themeMode: ThemeMode.dark,
    //       home: startWidgetScreen,
    //
    //       //home: EditProfile(),
    //     );
    //
    //    },
    //  ),);
    return  MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      //  themeMode: ThemeMode.dark,
      home: startWidgetScreen,

    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //makeToast('On Background Messaging App : ${message.data.toString()}');

}