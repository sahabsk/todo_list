import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  _authentication() {
    final valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (valid) {
      _formKey.currentState!.save();
      _submit(_email, _password, _username);
    }
  }

  _submit(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      if (isLoginPage) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'username': username,
          'email': email,
          'password': password,
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.name,
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter the Username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              // color: Colors.black
                              ),
                        ),
                        labelText: "Enter Username",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the email";
                      } else if (!value.contains("@")) {
                        return "Please enter the correct email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            // color: Colors.black
                            ),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    key: ValueKey("password"),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the password";
                      } else if (value.length < 6) {
                        return "Please enter the at least 6 character";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            // color: Colors.black
                            ),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        onPressed: () {
                          _authentication();
                        },
                        child: isLoginPage
                            ? Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              )
                            : Text(
                                "SignUp",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text("Don't have an account?")
                          : Text("Already have an account."),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
