// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujikom_tsa/build/panel.dart';
import 'package:ujikom_tsa/pages/dashboard.dart';
import 'package:ujikom_tsa/pages/register_page.dart';
import 'package:ujikom_tsa/utils/constant.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseDatabase fireDB = FirebaseDatabase.instance;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    cekUser();
  }

  cekUser() {
    getAuth().then((value) {
      if (value.value != null) {
        navigatorPushReplace(context, page: Dashboard());
      }
    });
  }

  login() async {
    try {
      var result = await fireDB.ref('user').get();
      var data = result.children.toList().where((item) {
        if ((item.value as dynamic)['username'] == username.text) {
          return true;
        }

        return false;
      });

      if (data.isEmpty) {
        notif(context, text: 'Username not found', color: kWrongColor);
      } else {
        for (var item in data) {
          if ((item.value as dynamic)['password'] == password.text) {
            SharedPreferences session = await SharedPreferences.getInstance();
            session.setString('auth', item.key.toString());

            notif(context, text: 'Login successfull', color: kSuccessColor);
            navigatorPushReplace(context, page: Dashboard());
            return true;
          }
        }

        notif(context, text: 'Wrong password', color: kWrongColor);
      }
    } catch (e) {
      notif(context, text: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: size.height * .45,
              width: size.width,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 75),
                  ClipPath(
                    // clipper: HeadClipper(),
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      width: double.infinity,
                      height: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/icon.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Panel(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      children: [
                        Text(
                          'LOGIN FORM',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Username',
                            label: Text('Username'),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            label: Text('Password'),
                          ),
                        ),
                        SizedBox(height: 40),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: kPrimaryColor,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: login,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account ? "),
                            GestureDetector(
                              onTap: () {
                                navigatorPushReplace(context, page: Register());
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
