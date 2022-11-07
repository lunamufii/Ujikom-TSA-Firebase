// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ujikom_tsa/build/panel.dart';
import 'package:ujikom_tsa/pages/login_page.dart';
import 'package:ujikom_tsa/pages/users.dart';
import 'package:ujikom_tsa/utils/constant.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseDatabase fireDB = FirebaseDatabase.instance;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController nomorTelepon = TextEditingController();

  register() async {
    try {
      var result = await fireDB.ref('user').get();
      var data = result.children.toList().where((item) {
        if ((item.value as dynamic)['username'] == username.text) {
          return true;
        }
        return false;
      });

      if (data.isEmpty) {
        await fireDB.ref('user').push().set({
          'username': username.text,
          'nama': nama.text,
          'password': password.text,
          'nomorTelepon': nomorTelepon.text,
          'role': '2',
        }).then((value) {
          notif(context,
              text: 'Registration successfull !', color: Colors.green);
          navigatorPushReplace(context, page: Login());
        });
      } else {
        notif(context, text: 'Username expired', color: Colors.red);
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
                  SizedBox(height: size.height * .15),
                  Panel(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      children: [
                        Text(
                          'REGISTER FORM',
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
                          validator: (v) {
                            if (v!.length < 13) {
                              return "Password needs to be more than 13 characters";
                            }
                            if (v.isEmpty) return "Enter a value";
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            label: Text('Password'),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: nama,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            label: Text('Name'),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: nomorTelepon,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '62',
                            label: Text('Phone Number'),
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
                                onTap: register,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'REGISTER',
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
                            Text("Have an account ? "),
                            GestureDetector(
                              onTap: () {
                                navigatorPushReplace(context, page: Login());
                              },
                              child: Text(
                                'Login',
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
