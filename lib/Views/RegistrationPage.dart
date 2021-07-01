import 'package:chat_app/Controllers/AuthAPI.dart';
import 'package:chat_app/Models/User.dart' as models;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'HomePage.dart';

class RegistrationDemo extends StatelessWidget {
  const RegistrationDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registration Page'),
        ),
        body: RegistrationPage(),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  SnackBar snackBar;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  Uuid uuid = Uuid();
  AuthAPI authAPI = AuthAPI();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextFormField(
            controller: fNameController,
            decoration: InputDecoration(
              labelText: "First Name",
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextFormField(
            controller: lNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
            ),
          ),
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
            register();
          },
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
        ),
      ],
    );
  }

  Future<void> register() async {
    String email = emailController.text.trim();
    String pwd = pwdController.text.trim();
    String fName = fNameController.text.trim();
    String lName = lNameController.text.trim();
    if (email.isEmpty || pwd.isEmpty || fName.isEmpty || lName.isEmpty) {
      snackBar = SnackBar(content: Text('All fields need to be filled!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String authRes = await authAPI.registerEmailPass(email, pwd);
    if (authRes != null) {
      snackBar = SnackBar(content: Text(authRes));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    models.User user = models.User(
        firstName: fName,
        lastName: lName,
        datetime: DateTime.now().toString(),
        role: 'customer',
        uid: FirebaseAuth.instance.currentUser.uid);
    var curUser = FirebaseAuth.instance.currentUser;
    print(user.toJson());
    String dbRes = await authAPI.createUser(user, curUser.uid);
    if (dbRes != null) {
      snackBar = SnackBar(content: Text(dbRes));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
