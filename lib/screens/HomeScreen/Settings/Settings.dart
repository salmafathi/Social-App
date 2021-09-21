import 'package:flutter/material.dart';
import 'package:social_app/shared/components/constants.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: TextButton(onPressed: () { signOutFun(context) ; }, child: Text('sign out'),));
  }
}
