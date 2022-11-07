// ignore_for_file: prefer_if_null_operators, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ujikom_tsa/utils/constant.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key, this.child, this.padding}) : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null ? padding : EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: kPrimaryColor.shade100, blurRadius: 4),
        ],
      ),
      child: child,
    );
  }
}
