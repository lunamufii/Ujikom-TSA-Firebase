import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujikom_tsa/utils/constant.dart';
import 'package:ujikom_tsa/pages/dashboard.dart';
import 'package:ujikom_tsa/pages/login_page.dart';
import 'package:ujikom_tsa/pages/profile.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: kShadowColor, blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Profil()));
            },
            color: kShadowColor,
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Dashboard()));
            },
            color: kShadowColor,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences session = await SharedPreferences.getInstance();
              await session.clear();

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Login()));
            },
            color: kShadowColor,
          ),
        ],
      ),
    );
  }
}