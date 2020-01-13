import 'package:blogger/blogger_classes/LoginRegisterPage.dart';
import 'package:blogger/blogger_classes/PhotoUpload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Mapping.dart';
import 'DialogBox.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatefulWidget{
  HomePage({
    this.auth,
    this.onSignedOut,
});
  final AuthImplemention auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
  
}


class _HomePageState extends State<HomePage>{

  List<Posts> postList = [];
  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef=FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS=snap.value.keys;
      var DATA=snap.value;
      postList.clear();
      for(var individualKey in KEYS){
        Posts posts=new Posts(
            DATA[individualKey]['image'],
            DATA[individualKey]['description'],
            DATA[individualKey]['date'],
            DATA[individualKey]['time'],
        );
        postList.add(posts);
      }
      setState(() {
        print("Length : "+postList.length.toString());
      });

    });
  }


    //method
    void _logoutUser()async
    {
      try{
        print("test 1");
        await widget.auth.SignOut();
        print("test 2");
        widget.onSignedOut;
        print("test 3");
        goToLoginRegisterPage();

      }
      catch(e){
        print("Error : "+e.toString());
      }
    }

    void goToLoginRegisterPage(){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context){
            return new LoginRegisterPage();
          })
      );
    }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Container(
        child: postList.length==0 ? new Text("No Blogger Posts Avaliable."):new ListView.builder(
            itemCount: postList.length,
            itemBuilder: (_,index){
              return postsUI(postList[index].image,postList[index].description,postList[index].date,postList[index].time);
            }
        ),

      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.pink,
        child: new Container(
          margin: const EdgeInsets.only(left: 60.0,right: 60.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.directions_walk),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: _logoutUser),
              new IconButton(icon: new Icon(Icons.add_a_photo),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: ()
                  {
                    Navigator.push
                      (
                        context,
                        MaterialPageRoute(builder: (context)
                        {
                          return new UploadPhotoPage();
                        })
                    );

                  }),
            ],
          ),
        ),
      ),

    );
  }
  Widget postsUI(String image , String description , String date , String time){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date ,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time ,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],

            ),
            SizedBox(height: 10.0,),
            
            new Image.network(image, fit: BoxFit.cover),

            SizedBox(height: 10.0,),
            new Text(
              description ,
              style: Theme.of(context).textTheme.subhead ,
              textAlign: TextAlign.center,
            ),



          ],
        ),
      ),
    );
  }
}


 




