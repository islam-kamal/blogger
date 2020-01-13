import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'HomePage.dart';
import 'Mapping.dart';
import 'DialogBox.dart';


class LoginRegisterPage extends StatefulWidget{
  final AuthImplemention auth;
  final VoidCallback onSignedIn;
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
});

  @override
  State<StatefulWidget> createState() {
    return _LoginRegisterSate();
  }

}

enum FormType{
  login,
  register
}

class _LoginRegisterSate extends State<LoginRegisterPage>{

  DialogBox dialogBox=new DialogBox();

  final formKey=new GlobalKey<FormState>();
  FormType _formType=FormType.login;
  String _email="";
  String _password="";


  //methods ...............................................................
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

  void validateAndSubmit()async{

    if(validateAndSave()){
      try{
       if(_formType==FormType.login){
         print("test 11-1");
         String userId = await widget.auth.Signin(_email,_password);
         print("test 11-2");
         dialogBox.information(context, "Congratulation","your are logged successfully");
         print("test 11-3");
         goToHomePage();
         print("login userId = "+userId);
         print("test 11-4");
       }
       else
         {
           String userId = await widget.auth.SignUp(_email,_password);
           dialogBox.information(context, "Congratulation","your Account created successfully");
           goToLoginPage();

           print("login userId = "+userId);
         }
       widget.onSignedIn();

      }
      catch(e){
        dialogBox.information(context, "Error", e.toString());
        print("Error : "+e.toString());

      }
    }

  }
  void goToLoginPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new LoginRegisterPage();
        })
    );
  }
  void goToHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new LoginRegisterPage();
        })
    );
  }

  moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.register;
    });

  }
  moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });

  }


  //Design .......................................................................

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Blogger App"),
        
      ),
      body: new Container(
        margin:EdgeInsets.all(15.5),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: creatInputs() + createButtons(),

          ),

      )
      ),
    );
  }
  List<Widget> creatInputs (){
    return [
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),
      new TextFormField(
        decoration: new InputDecoration(labelText: "Email"),
        validator: (value){
          return value.isEmpty ? 'email is required':null;
        },
        onSaved: (value){
          return _email=value;
        },
      ),
      SizedBox(height: 10.0,),
      new TextFormField(
        decoration: new InputDecoration(labelText: "password"),
        obscureText: true,
        validator: (value){
          return value.isEmpty ? 'password is required':null;
        },
        onSaved: (value){
          return _password=value;
        },
      ),
      SizedBox(height: 20.0,),


    ];
  }
  Widget logo(){
    return new Hero(
      tag: "hero",
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset("images/logo.png"),
      ),
    );
  }
  List<Widget> createButtons(){
    if(_formType==FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0),),
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: validateAndSubmit,

        ),
        SizedBox(height: 10.0,),
        new FlatButton(
          child: new Text("Not Have Account ? , Create New Account"),
          textColor: Colors.deepOrange,
          onPressed: moveToRegister,
        ),


      ];

    }
    else{
      return [
        new RaisedButton(
          child: new Text("Create Account", style: new TextStyle(fontSize: 20.0),),
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: validateAndSubmit,
        ),
        SizedBox(height: 10.0,),
        new FlatButton(
          child: new Text("Already Have Account ? Login"),
          textColor: Colors.deepOrange,
          onPressed: moveToLogin,
        ),


      ];
    }
  }
}