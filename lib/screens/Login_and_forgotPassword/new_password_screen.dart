import '../../values/strings_en.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './clipper_widget.dart';
import '../../values/app_colors.dart';

class NewPasswordScreen extends StatefulWidget {
  static const route = '/new-password';

  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool passwordValidationError = false;
  bool confirmPasswordValidationError = false;

  void resetPassword() {
    setState(() {});
    _formkey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    TextEditingController passwordController = TextEditingController();
    String newPassword = '';
    final appbar = AppBar(
      title: Text(
        dotenv.get('APP_TITLE'),
        style: const TextStyle(
            fontFamily: 'Maginia',
            fontWeight: FontWeight.bold,
            color: appBarTitleColor),
      ),
      backgroundColor: primaryColor,
    );
    return Scaffold(
      appBar: appbar,
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height -
              appbar.preferredSize.height -
              MediaQuery.of(context).viewPadding.top,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: ClipperStyle(secondStyleUi),
                    child: Container(
                      color: primaryColor.withOpacity(0.7),
                      height: height * 32,
                      width: deviceSize.width,
                    ),
                  ),
                ],
              ),

              ClipPath(
                clipper: ClipperStyle2(secondStyleUi),
                child: Container(
                  color: primaryColor.withOpacity(0.3),
                  height: deviceSize.height * 0.35,
                  width: deviceSize.width,
                ),
              ),
              if (secondStyleUi)
                ClipPath(
                  clipper: ClipperStyle3(secondStyleUi),
                  child: Container(
                    color: primaryColor.withOpacity(0.2),
                    height: deviceSize.height * 0.36,
                    width: deviceSize.width,
                  ),
                ),
              if (!secondStyleUi)
                Container(
                  height: height * 25,
                  padding: EdgeInsets.only(right: width * 2),
                  alignment: Alignment.bottomRight,
                  child: const Text(
                    TITLE_NEW_PASSWORD,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                      // fontFamily: 'Maginia',
                      // fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              // Container(
              //   height: deviceSize.height,
              //   width: double.infinity,
              //   child:
              // Image.asset(
              //         fit: BoxFit.cover,
              // 'assets/makeup-brushes-on-marble.jpg'),

              Container(
                width: deviceSize.width,
                alignment:
                    secondStyleUi ? Alignment.topCenter : Alignment.topLeft,
                color: Colors.transparent,
                // height: deviceSize.height * 0.3,
                padding: EdgeInsets.only(
                    top: deviceSize.height * 0.03,
                    left: secondStyleUi ? 0 : deviceSize.width * 0.05),

                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: primaryColor)),
                  child: Image.asset(
                    'assets/launcher_icon_removedbg.png',
                    fit: BoxFit.scaleDown,
                    color: primaryColor,
                    height: deviceSize.height * 0.2,
                    width: deviceSize.height * 0.2,
                  ),
                ),
              ),
              Container(
                height: deviceSize.height,
                padding: EdgeInsets.only(top: deviceSize.height * 0.2),
                child: Form(
                  key: _formkey,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: width * 3,
                      right: width * 3,
                      top: height * 3,
                      bottom: height * 3,
                    ),
                    // height: deviceSize.height * 0.6,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 10,
                        ),
                        if (secondStyleUi)
                          const Text(
                            TITLE_CONFIRM_NEW_PASSWORD,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              // fontFamily: 'Maginia',
                              // fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        SizedBox(
                          height: height * 3,
                        ),
                        const Text(TITLE_FORGOT_PASSWORD_CONTENT),
                        SizedBox(
                          height: height * 3,
                        ),
                        Container(
                          // height: deviceSize.height * 0.1 +
                          //     ((emailValidationError ? 1 : 0) *
                          //         (deviceSize.height * 0.03)),
                          padding: EdgeInsets.only(
                              left: width * 2.6, right: width * 2.6),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: height),
                                alignment: Alignment.centerLeft,
                                height: height * 3.5,
                                color: Colors.transparent,
                                child: const Text(
                                  TITLE_NEW_PASSWORD,
                                  style: TextStyle(color: textInputTitleColor),
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.07 +
                                    ((passwordValidationError ? 1 : 0) *
                                        (deviceSize.height * 0.03)),
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.top,
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                    focusColor: primaryColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  validator: (value) {
                                    if (value!.length < 6) {
                                      passwordValidationError = true;
                                      if (kDebugMode) {
                                        print(passwordValidationError);
                                      }
                                      return TITLE_PASSWORD_IS_SHORT;
                                    } else {
                                      passwordValidationError = false;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    newPassword = value!;
                                    if (kDebugMode) {
                                      print(
                                          newPassword); //remove after connecting with api
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: width * 2.6, right: width * 2.6),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: height),
                                alignment: Alignment.centerLeft,
                                height: height * 3.5,
                                color: Colors.transparent,
                                child: const Text(
                                  TITLE_CONFIRM_NEW_PASSWORD,
                                  style: TextStyle(color: textInputTitleColor),
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.07 +
                                    ((confirmPasswordValidationError ? 1 : 0) *
                                        (deviceSize.height * 0.03)),
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.top,
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                    focusColor: primaryColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  validator: (value) {
                                    if (value == passwordController.text) {
                                      confirmPasswordValidationError = true;
                                      if (kDebugMode) {
                                        print(confirmPasswordValidationError);
                                      }
                                      return TITLE_PASSWORD_NOT_MATCH;
                                    } else {
                                      confirmPasswordValidationError = false;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 7,
                              width: width * 25,
                              child: ElevatedButton(
                                onPressed: () {
                                  resetPassword();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    primary: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 5,
                                        vertical: height)),
                                child: const Text(
                                  TITLE_SAVE,
                                  // textScaleFactor: 1.4,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: buttonTextColor,
                                    // color:Colors.white,
                                    // fontWeight: FontWeight.w500,
                                    // fontFamily: 'Frost',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
