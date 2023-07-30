import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_assessment/screens/forgot_password_screen.dart';
import 'package:internal_assessment/screens/sign_up_screen.dart';
import './main_app_screen.dart';

class LoginScreen extends StatefulWidget {
   static const String routeName = '/loginscreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  Future<FirebaseApp> initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> loginUsingEmailPassword
      (String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;


    try{
      UserCredential userCredential = await
      auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;



    } on FirebaseAuthException catch (e) {
        showDialog(context: context, builder: (builder) {
          return AlertDialog(
            title: Center(
                child: Text("User account not found")),);
        });
    }

    
    return user;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(appBar: AppBar(title: Text("")), body: FutureBuilder(future: initializeFirebase(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        return Padding(
            padding: EdgeInsets.all(25),
            child: Container(alignment: Alignment.topCenter, child: SingleChildScrollView(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'English Learning App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                      //forgot password screen
                    },
                    child: const Text('Forgot Password',),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(emailController.text, passwordController.text, context);
                      if(user != null){
                        Navigator.of(context).pushReplacementNamed(MainAppScreen.routeName);
                      }
                        // Navigator.pushReplacementNamed(context, MainAppScreen.routeName);
                        },
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Don\'t have an account?'),
                      TextButton(
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          //signup screen
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                      )
                    ],
                  )]),
            )));}
      return const Center(child: CircularProgressIndicator());
    }),);
  }
}