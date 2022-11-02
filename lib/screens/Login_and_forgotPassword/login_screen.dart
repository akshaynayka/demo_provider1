import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './clipper_widget.dart';
import '../../values/app_colors.dart';
import '../../model/http_exception.dart';
import '../../provider/auth.dart';
import '../../values/strings_en.dart';
import '../../values/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _scrollkey = GlobalKey();
  bool passwordValidattionError = false;
  bool emailValidationError = false;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  Future<void> _submit() async {
    setState(() {});
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email']!,
        _authData['password']!,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This not valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'password is to weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(TITLE_ERROR_OCCURED),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              TITLE_OKAY,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    return Scaffold(
      body: SingleChildScrollView(
        key: _scrollkey,
        child: SizedBox(
          height: deviceSize.height,
          child: Stack(
            // alignment: Alignment.center,
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: ClipperLoginStyle(),
                    child: Container(
                      color: primaryColor.withOpacity(0.7),
                      height: height * 37,
                      width: deviceSize.width,
                    ),
                  ),
                  Text(
                    dotenv.get('APP_TITLE'),
                    textScaleFactor: 1.7,
                    style: const TextStyle(
                      fontFamily: 'Maginia',
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),

              ClipPath(
                clipper: ClipperLoginStyle2(),
                child: Container(
                  color: primaryColor.withOpacity(0.3),
                  height: deviceSize.height * 0.39,
                  width: deviceSize.width,
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
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                // height: deviceSize.height * 0.3,
                padding: EdgeInsets.only(
                    top: deviceSize.height * 0.07,
                    left: deviceSize.width * 0.05),
                // color: Theme.of(context).primaryColor.withOpacity(0.85),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: primaryColor)),
                  child: Image.asset(
                    'assets/launcher_icon_removedbg.png',
                    fit: BoxFit.scaleDown,
                    color: primaryColor,
                    // color: Colors.white,
                    height: deviceSize.height * 0.2,
                    width: deviceSize.height * 0.2,
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: deviceSize.height,
                padding: EdgeInsets.only(
                    left: deviceSize.height * 0.07,
                    right: deviceSize.height * 0.07,
                    bottom: deviceSize.height * 0.02),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Expanded(child: SizedBox()),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: height * 3,
                              color: Colors.transparent,
                              child: const Text(
                                'Email',
                                style: TextStyle(color: textInputTitleColor),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.07 +
                                  ((emailValidationError ? 1 : 0) *
                                      (deviceSize.height * 0.03)),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.top,
                                cursorColor: primaryColor,
                                // style: TextStyle(
                                // height: 0.6,
                                // textBaseline: TextBaseline.alphabetic),
                                // initialValue: 'demo_provider1@gmail.com',
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
                                  // prefixIcon: const Icon(Icons.mail_outline_rounded),
                                  // labelText: TITLE_EMAIL,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    emailValidationError = true;

                                    return TITLE_INVALID_EMAIL;
                                  } else {
                                    emailValidationError = false;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['email'] = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 2,
                        ),
                        SizedBox(
                          height: height * 3,
                          child: const Text(
                            TITLE_PASSWORD,
                            style: TextStyle(color: textInputTitleColor),
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.07 +
                              ((passwordValidattionError ? 1 : 0) *
                                  (deviceSize.height * 0.03)),
                          child: TextFormField(
                            // initialValue: '12345678',
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              // prefixIcon: const Icon(Icons.lock_outline_rounded),
                              // labelText: TITLE_PASSWORD,
                            ),
                            obscureText: true,
                            onEditingComplete: () {
                              _submit();
                            },
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                passwordValidattionError = true;
                                return TITLE_PASSWORD_IS_SHORT;
                              } else {
                                passwordValidattionError = false;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height:
                              (emailValidationError || passwordValidattionError)
                                  ? height * 3
                                  : height * 5,
                        ),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: deviceSize.height * 0.07,
                                width: width * 15,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                      // alignment: AlignmentDirectional.topCenter,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 4,
                                          vertical: height)),
                                  child: const Text(
                                    TITLE_LOGIN,
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
                        SizedBox(
                          height:
                              // (emailValidationError || passwordValidattionError)
                              //     ? height * 1 :
                              height * 1,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(APP_ROUTE_SUPPORT_SCREEN);
                              },
                              child: const Text(
                                'Get Support ?',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(APP_ROUTE_FORGOT_PASSWORD);
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: primaryColor),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: height * 3,
                        )
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
