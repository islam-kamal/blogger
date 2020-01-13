import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'HomePage.dart';
import 'LoginRegisterPage.dart';

class MappingPage extends StatefulWidget{
  final AuthImplemention auth;
  MappingPage({
    this.auth,
});
  @override
  State<StatefulWidget> createState() {
    return _MappingPageState();

  }

}
enum AuthState
{
  notSignedIn,
  SignedIn,
}


class _MappingPageState extends State<MappingPage>{
  AuthState authState=AuthState.notSignedIn;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId){
      setState(() {
        authState=firebaseUserId==null?AuthState.notSignedIn:AuthState.SignedIn;
      });

    }

    );
  }
  void _signedIn(){
    authState=AuthState.SignedIn;
  }
  void _signeOut(){
    authState=AuthState.notSignedIn;

  }



  @override
  Widget build(BuildContext context) {
    switch(authState){
      case AuthState.notSignedIn:
        return new LoginRegisterPage(
          auth:widget.auth,
          onSignedIn:_signedIn
        );
      case AuthState.SignedIn:
        return new HomePage(
            auth:widget.auth,
            onSignedOut:_signeOut
        );
    }
    return null;
  }
}