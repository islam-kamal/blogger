import 'package:blogger/blogger_classes/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:blogger/blogger_classes/HomePage.dart';
import 'package:blogger/blogger_classes/Authentication.dart';
import 'package:blogger/blogger_classes/Mapping.dart';
void main(){
  runApp(new MyBlogger());
}

class  MyBlogger extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blogger",
      theme: new ThemeData(
        primarySwatch: Colors.pink
      ),
      home: MappingPage(auth:Auth(),),
    );
  }

}