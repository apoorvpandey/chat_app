
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';
class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isLoading = false;

  QuerySnapshot snapshotUserInfo;

  final formKey = GlobalKey<FormState> ();

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "PLease provide a valid email address";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration:textFieldInputDecoration("Email")
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return val.length > 6 ? null : "Password must be at least char";
                      },
                      controller: passwordTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Password"),
                    ),
                  ],),
                ),
                SizedBox(height: 8,),
               Container(
                 alignment: Alignment.centerRight,
                 child:  Container(
                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   child: Text("Forgot Password?", style: simpleTextStyle(),),
                 ),
               ),
                SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: [
                        const Color(0xff007ef4),
                        const Color(0xff2a75bc)
                      ]
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text ("Sign in", style: mediumTextStyle()),
                ),
                  ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text ("Sign in with Google", style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  )),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text ("Don't have an Account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register now", style: TextStyle (
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline
                        ),
                        )
                        ,
                      ),

                    )
                    ,
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() {
    if(formKey.currentState.validate()){

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
     // HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;

        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });

      setState(() {
        isLoading=true;
      });



      authMethods.signInWIthEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
       if(val != null)
         {

           HelperFunctions.saveUserLoggedInSharedPreference(true);

           Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context) => ChatRoom(),
           ));
         }
      });



    }
  }
}
