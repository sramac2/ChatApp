import 'dart:async';

import 'package:chat_app/Controllers/AuthAPI.dart';
import 'package:chat_app/Views/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'RegistrationPage.dart';

class LoginDemo extends StatelessWidget {
  const LoginDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthAPI api = AuthAPI();
  TextEditingController emailController;
  TextEditingController pwdController;
  StreamController<String> emailStreamController;
  StreamController<String> pwdStreamController;
  SnackBar snackBar;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    emailController = TextEditingController();
    pwdController = TextEditingController();
    emailController.text = 'testing@gmail.com';
    pwdController.text = 'testing';
    emailStreamController = StreamController<String>.broadcast();
    pwdStreamController = StreamController<String>.broadcast();

    BuildContext currentCtx;
    snackBar = SnackBar(content: Text('Test'));
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error Initializing Firebase'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                Text(
                  'Login Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: pwdController,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationDemo()));
                  },
                  child: Text("Don't have an account?"),
                )
              ],
            )),
          );
        });
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String pwd = pwdController.text.trim();
    if (email.isEmpty || pwd.isEmpty) {
      snackBar = SnackBar(content: Text('All fields need to be filled!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String response = await api.loginUserEmailPass(email, pwd);
    if (response != null) {
      snackBar = SnackBar(content: Text(response));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
