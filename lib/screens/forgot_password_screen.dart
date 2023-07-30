import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_assessment/screens/login_screen.dart';
import './main_app_screen.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password-screen';

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;


    return Scaffold(
      appBar: AppBar(title: Text("English Learning App",)),
      body:
        Center(child: Column(children: [
          SizedBox(height: 50,),
          Text('Enter your account email.'),
          TextFormField(
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
          ),
          SizedBox(height: 20,),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              onPressed: () => resetPassword(),
              icon: Icon(Icons.email_outlined), label: Text('Reset Password'))
        ],),)
      ,);
  }

  Future resetPassword() async{
    print(emailController.text);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      showDialog(context: context, builder: (builder){
        return AlertDialog(title: Center(child: Text("Verification email sent")),);
      });
    } on FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context, builder: (builder){
        return AlertDialog(title: Center(child: Text(e.message as String)),);
      });
    }

  }
}