import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';

class UploadPhotoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }

}

class _UploadPhotoPageState extends State<UploadPhotoPage>{
  File sampleImage;
  String _myValue;
  String url;
  final formKey=new GlobalKey<FormState>();

  //methods ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

  Future getImage()async{
    var tempImage= await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage=tempImage;
    });
  }

  bool validateAndSave(){
    final form=formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void uploadStatusImage()async
  {
    if(validateAndSave()){
      final StorageReference postImageRef=FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask=postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);
      var ImageUrl=await(await uploadTask.onComplete).ref.getDownloadURL();
      url=ImageUrl.toString();
      print("Image Url : "+url);
      saveToDatabase(url);
      goToHomePage(); // return to home page after save data
    }
  }

  void saveToDatabase(url){
    var dbTimeKey=new DateTime.now();
    var formateDate=new DateFormat('MMM d, yyyy');
    var formateTime=new DateFormat('EEEE, hh:mm aaa');
    String date=formateDate.format(dbTimeKey);
    String time=formateTime.format(dbTimeKey);
//we make random key to store image but we will use userid to store image to unique user
    DatabaseReference ref=FirebaseDatabase.instance.reference();

    var data = {
      "image" : url,
      "description" : _myValue ,
      "date" : date ,
      "time" :time ,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new HomePage();
        })
    );
  }



  // design ..........................................

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Photo"),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage==null?Text("select an image"):enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
        tooltip: "Add Image",
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget enableUpload(){
    return Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0,),
            Image.file(sampleImage,height: 200.0 ,width: 900.0),
            SizedBox(height: 35.0,),
            TextFormField(
              decoration: new InputDecoration(labelText: "Description"),
              validator: (value){
                return value.isEmpty?"Description field is required":null;
              },
              onSaved: (value){
                return _myValue=value;
              },

            ),
            SizedBox(height: 55.0,),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add New Post"),
              color: Colors.pink,
              textColor: Colors.white,
              onPressed: uploadStatusImage,

            ),
          ],
        ),
      ),
    );
  }
}