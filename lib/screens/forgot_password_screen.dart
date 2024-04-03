import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool verificationSent = false;
  String resendTime = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: size.height,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.arrow_back_ios),
                            ),
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: fontSizeStandard
                              ),
                            ),
                            SizedBox(width: 20,),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(verificationSent)
                                Container(
                                  height: size.height / 2,
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "We've sent the password reset link please check your mail and click on the link to set the new password",
                                        style: TextStyle(
                                          fontSize: fontSizeSmall,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                SizedBox(
                                  width: size.width / 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: marginXLarge,),
                                      Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          fontSize: fontSizeLarge,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(height: defaultPadding,),
                                      Text("Enter your email, we will send a reset link to email",
                                        style: TextStyle(
                                          color: COLOR_GREY_LIGHT
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if(!verificationSent)
                                Container(
                                width: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                height: 70,
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: SizedBox(
                                        width: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            border: Border.all(color: COLOR_BLACK),
                                          ),
                                          child: Icon(Icons.email,),
                                        ),
                                      ),
                                    ),
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
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5),
                                      // fontSize: Adaptive.h(2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email address";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Visibility(
                                visible: verificationSent,
                                child: Spacer()
                              ),
                              Visibility(
                                visible: verificationSent,
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Resend link in ',
                                      style: TextStyle(
                                        color: COLOR_GREY_LIGHT, fontSize: 18),
                                      children: <TextSpan>[
                                        TextSpan(text: '${resendTime}s',
                                          style: TextStyle(
                                          color: COLOR_BLACK, fontSize: 18),
                                        )
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if(verificationSent) {
                                        setState(() {
                                          verificationSent = false;
                                        });
                                        // Navigator.pop(context);
                                      } else {
                                        setState(() {
                                          verificationSent = false;
                                        });
                                        // if (_formKey.currentState.validate()) {
                                        //   // _createAccount();
                                        // }
                                      }
                                    },
                                    child: Text(
                                      verificationSent ? "Done" : "Send",
                                      style: TextStyle(
                                        color: COLOR_WHITE,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              SizedBox(height: 40,),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
