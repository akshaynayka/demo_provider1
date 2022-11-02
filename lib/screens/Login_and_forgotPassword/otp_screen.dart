import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../values/app_colors.dart';
import './clipper_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  static final _formkey = GlobalKey<FormState>();

  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = 'myEmail@email.com';
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    int oTp = 0;

    submit() {
      if (!_formkey.currentState!.validate()) {
        return;
      }
      Navigator.of(context).pushNamed(APP_ROUTE_NEW_PASSWORD_SCREEN);
      _formkey.currentState!.save();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
          style: const TextStyle(
              fontFamily: 'Maginia',
              fontWeight: FontWeight.bold,
              color: appBarTitleColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SizedBox(
          height: deviceSize.height,
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
                  padding: EdgeInsets.only(right: width * 5),
                  alignment: Alignment.bottomRight,
                  child: const Text(
                    TITLE_OTP_VERIFICATION,
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
              Positioned(
                top: deviceSize.height * 0.25,
                left: 10.0,
                right: 10.0,
                child: Form(
                  key: _formkey,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    // height: deviceSize.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 4,
                          ),
                          if (secondStyleUi)
                            Container(
                              height: height * 6,
                              alignment: Alignment.center,
                              child: const Text(
                                TITLE_OTP_VERIFICATION,
                                textScaleFactor: 1.3,
                                style: TextStyle(
                                  // fontFamily: 'Maginia',
                                  // fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          Text('$TITLE_OTP_VERIFICATION_CONTENT $email'),
                          // ${email.replaceRange(email.indexOf('@') - 3, email.indexOf('@'), '***')}'),
                          SizedBox(
                            height: height * 2,
                          ),
                          PinCodeTextField(
                            pinTheme: PinTheme(
                                selectedColor: primaryColor,
                                borderWidth: 1,
                                activeColor: primaryColor,
                                inactiveColor: subtitleColor,
                                activeFillColor: primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            appContext: context,
                            length: 6,
                            keyboardType: TextInputType.number,
                            animationCurve: Curves.linearToEaseOut,
                            cursorColor: primaryColor,
                            // validator: (v) {
                            //   if (v!.length < 6) {
                            //     return 'OTP NOT VALID!!';
                            //   }
                            // },
                            onSaved: (value) {
                              oTp = int.parse(value!);
                              if (kDebugMode) {
                                print(oTp); // remove when api is integrated
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (String value) {},
                          ),

                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              const Text("Didn't recived the OTP ?"),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Re-Send OTP',
                                  style: TextStyle(color: primaryColor),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: height * 1,
                          // ),
                          SizedBox(
                            width: width * 20,
                            height: height * 7,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  primary: primaryColor),
                              child: const Text('Submit',
                                  style: TextStyle(
                                      color: buttonTextColor, fontSize: 16)),
                              onPressed: () {
                                submit();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
