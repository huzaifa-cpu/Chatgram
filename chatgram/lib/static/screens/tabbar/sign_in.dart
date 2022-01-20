import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/widgets/buttons/custom_animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/static/widgets/textfields/custom_textfield.dart';
import '../../widgets/textfields/custom_textfield.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Repository _repository = Repository();

  SharedPref pref = SharedPref();

  bool google = false;
  bool signin = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;
  static const String TAG = "LoginScreen";
  String uid;

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: loading
          ? Center(child: Loader('Signing In...'))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    CustomTextField(
                      type: TextInputType.emailAddress,
                      validator: (val) => val.isEmpty ? '' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      hintStyle: theme.textTheme.headline5,
                      obscureText: false,
                      hint: "abc@gmail.com",
                      icon: Icon(
                        Icons.email,
                        color: theme.primaryColor,
                      ),
                      label: "Enter your email",
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomTextField(
                      hintStyle: theme.textTheme.headline5,
                      obscureText: true,
                      hint: "Enter 7-digit password",
                      validator: (val) => val.length < 6 ? '' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      icon: Icon(
                        Icons.visibility_off,
                        color: theme.primaryColor,
                      ),
                      label: "Enter your password",
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    CustomAnimatedButton(
                      text: "Sign In",
                      changeButton: signin,
                      onPressed: () async {
                        setState(() {
                          signin = !signin;
                          loading = true;
                        });
                        if (_formKey.currentState.validate()) {
                          await performEmailPasswordLogin(email, password);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Invalid email or password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.grey[500],
                              textColor: theme.primaryColor,
                              fontSize: 14);
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.grey,
                          width: width * 0.38,
                          height: height * 0.001,
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(
                          "OR",
                          style: theme.textTheme.headline5,
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          color: Colors.grey,
                          width: width * 0.38,
                          height: height * 0.001,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomAnimatedButton(
                      text: "Sign in with Google",
                      changeButton: google,
                      onPressed: () async {
                        setState(() {
                          google = !google;
                          loading = true;
                        });
                        Future.delayed(Duration(seconds: 1), () async {
                          //SIGN IN WITH GOOGLE
                          await performLogin();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }

  //FIREBASE REGISTRATION
  Future performLogin() async {
    print("tring to perform login");

    await _repository.signInWithGoogle().then((User user) async {
      if (user != null) {
        await authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  Future performEmailPasswordLogin(String email, String password) async {
    print("tring to perform login");
    await _repository
        .signInWithEmailAndPassword(email, password)
        .then((User user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  Future authenticateUser(User user) async {
    await _repository.authenticateUser(user).then((isNewUser) async {
      if (isNewUser) {
        await _repository.insertUser(user);
        await FirebaseFirestore.instance
            .collection("chatlist")
            .doc(user.uid)
            .collection(user.uid)
            .doc("INITIALS")
            .set({
          "uid": "initial",
          "timestamp": "initial",
          "message": "initial",
          "profilePhoto": "initial",
          "name": "initial",
          "self-destruct": false,
        });
        await FirebaseFirestore.instance
            .collection("requests")
            .doc(user.uid)
            .collection(user.uid)
            .doc("INITIALS")
            .set({
          "uid": "initial",
        });
        await FirebaseFirestore.instance
            .collection("grouplist")
            .doc(user.uid)
            .collection(user.uid)
            .doc("INITIALS")
            .set({
          "uid": "initial",
          "groupName": "initial",
          "message": "initial",
          "timestamp": "initial",
          "imageUrl": "initial"
        });
      } else {
        print('user already exist');
      }
    });
  }
}
