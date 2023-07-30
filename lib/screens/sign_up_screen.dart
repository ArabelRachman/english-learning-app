import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_assessment/screens/login_screen.dart';
import './main_app_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late DatabaseReference _ref;

  Future<FirebaseApp> initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> loginUsingEmailPassword(String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        print("Invalid credentials");
      }
    }

    return user;
  }

  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.ref('usernames');
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(appBar: AppBar(title: Text("English Learning App",)), body: FutureBuilder(future: initializeFirebase(), builder: (context, snapshot) {
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
                        'Sign up',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Create your account',
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
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      controller: passwordConfirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ),

                  Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),

                      child: ElevatedButton(
                        child: const Text('Sign Up'),
                        onPressed: () async {
                          if(passwordController.text == passwordConfirmController.text){
                            print(passwordController.text);
                          try {
                            int idx = emailController.text.indexOf('@');
                            String emailPath = emailController.text.substring(0, idx).trim();

                            await _ref.child(emailPath).set(usernameController.text);

                            final newUser = await
                                auth.createUserWithEmailAndPassword
                                  (email: emailController.text, password: passwordController.text);
                            print(newUser.user);

                            if(newUser != null){
                              Navigator.pop(context);
                                  /* Navigator.po
                                    (context, LoginScreen.routeName);*/
                                }
                          } catch(e){
                        //    print(e);
                            showDialog(context: context, builder: (builder) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(e.toString())),);
                            });
                          }
                      } else {
                            print("doesnt match");
                            showDialog(context: context, builder: (builder) {
                              return AlertDialog(
                                title: Center(
                                    child: Text('Passwords do not match')));
                            });
                          }
                        },
                      )
                  ),
]),
            )));}
      return const Center(child: CircularProgressIndicator());
    }),);
  }
}