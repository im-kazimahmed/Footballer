import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footballer/components/agree_terms_and_conditions.dart';
import 'package:footballer/components/ui_helper.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../models/user_model.dart';
import '../screens/home/home.dart';
import '../screens/login.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _createAccount() async {
    UserCredential credential;

    setState(() {
      isLoading = true;
    });
    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text
      );
    } on FirebaseAuthException catch(ex){
      UIHelper.showAlertDialog(context, "Error", "An error occurred: ${ex.message}");

      setState(() {
        isLoading = false;
      });
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd, MM, yyyy, kk:mm a').format(now);

    if(credential != null) {
      String uid = credential.user.uid;
      UserModel newUser = UserModel(
        createdAt: formattedDate,
        fullName: _nameController.text,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance.collection(
        "users").doc(uid).set(
        newUser.toMap()).then((value) {
        log("new user created");
        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.route,
              (route) => false,
        );
      });
    }
  }

  @override
  void dispose() {
    _nameController?.dispose();
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
              Text('Full Name'),
              SizedBox(height: 5,),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                isPassword: false,
                hintText: "Enter your full name",
                validationError: 'Please enter your name',
              ),
            ],
          ),
          SizedBox(height: 20,),
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
                _createAccount();
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
                  "Continue with Email",
                  style: TextStyle(
                    color: COLOR_WHITE
                  ),
                ),
              )
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding),
          BySigningUpYouAgreeToOurTerms(
            press: () {

            },
            login: false,
          ),
          SizedBox(height: 20,),
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
