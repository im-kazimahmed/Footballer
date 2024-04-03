import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footballer/components/forgot_password.dart';
import 'package:footballer/components/ui_helper.dart';
import 'package:footballer/screens/forgot_password_screen.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../models/user_model.dart';
import '../screens/home/home.dart';
import '../screens/signup.dart';

class LoginForm extends StatefulWidget {

  LoginForm({
    Key key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _signIn() async {
    UserCredential credential;

    setState(() {
      isLoading = true;
    });

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (ex) {
      UIHelper.showAlertDialog(
        context,
        "Error",
        "An error occurred: ${ex.message}",
      );

      setState(() {
        isLoading = false;
      });
    }

    if (credential != null) {
      String uid = credential.user.uid;

      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userSnapshot.exists) {
        UserModel user = UserModel.fromMap(userSnapshot.data());
        log("Signed in user: ${user.fullName}");

        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.route, (route) => false,);
      } else {
        UIHelper.showAlertDialog(
          context,
          "Error",
          "User not found",
        );

        setState(() {
          isLoading = false;
        });
      }
    } else {
      UIHelper.showAlertDialog(
        context,
        "Error",
        "Invalid email or password",
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email',),
              SizedBox(height: 5,),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintText: "Enter your email address",
                isPassword: false,
                validationError: "Please enter your email address",
              )
            ],
          ),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Password',),
              SizedBox(height: 5,),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                hintText: "Enter your password",
                isPassword: true,
                validationError: "Please enter your password",
              )
            ],
          ),
          const SizedBox(height: defaultPadding),
          InkWell(
            onTap: isLoading ? (){} :() {
              if (_formKey.currentState.validate()) {
                _signIn();
              }
            },
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: isLoading ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(COLOR_WHITE),
                    ),
                  ): Text(
                    "Login",
                    style: TextStyle(
                        color: COLOR_WHITE
                    ),
                  ),
                )
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          ForgotPassword(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ForgotPasswordScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class TextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final String validationError;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const TextField({Key key, this.controller, this.isPassword, this.hintText, this.validationError, this.keyboardType, this.textInputAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return               Container(
      width: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      height: 70,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffed6e9f).withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(20)),
          errorStyle: TextStyle(
            color: Color(0xffed6e9f),
            fontSize: 12,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(20)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.5),
            // fontSize: Adaptive.h(2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationError;
          }
          return null;
        },
        obscureText: isPassword,
      ),
    );
  }
}