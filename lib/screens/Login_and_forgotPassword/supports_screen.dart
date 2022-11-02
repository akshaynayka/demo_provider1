import '../../screens/Login_and_forgotPassword/clipper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../common_methods/common_methods.dart';
import '../../provider/supports.dart';
import '../../values/app_colors.dart';
import '../../values/strings_en.dart';

class SupportsScren extends StatefulWidget {
  const SupportsScren({Key? key}) : super(key: key);

  @override
  SupportsScrenState createState() => SupportsScrenState();
}

class SupportsScrenState extends State<SupportsScren> {
  final _form = GlobalKey<FormState>();
  double height = 0;
  double width = 0;
  bool nameValidator = false;
  bool emailValidator = false;
  bool contentValidator = false;
  // var _isLoading = false;
  // HttpRequest _httpRequest = new HttpRequest();

  Map<String, String> supportData = {
    'name': '',
    'email': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    final deviceSize = MediaQuery.of(context).size;
    height = deviceSize.height * 0.01;
    width = deviceSize.width * 0.02;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    String status = 'Error';
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    // setState(() {
    //   _isLoading = true;
    // });

    try {
      final response = await Provider.of<Supports>(context, listen: false)
          .addSupportsData(supportData, context);
      // final response = await _httpRequest.postRequest(
      //     API_SUPPORTS, supportData, '', context);

      if (response == true) {
        status = 'Added';
      }
    } catch (error) {
      await showErrorDialog(TITLE_ERROR_WENT_WRONG, context);
    }
    if (!mounted) return;
    displaySnackbar(context, 'Your message', status);
  }

  Widget getTextfieldContainer(String title, bool validater, Widget child) {
    return SizedBox(
      height: height * 13.2,
      // width: width * 35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: textInputTitleColor),
          ),
          SizedBox(
            height: height,
          ),
          SizedBox(
              height: height * 7 + ((validater ? 1 : 0) * (height * 3)),
              child: child)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      title: Text(
        dotenv.get('APP_TITLE'),
        style: const TextStyle(
            fontFamily: 'Maginia',
            fontWeight: FontWeight.bold,
            color: appBarTitleColor),
      ),
    );
    return Scaffold(
      appBar: appbar,
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: height * 100 -
              (MediaQuery.of(context).viewPadding.top +
                  appbar.preferredSize.height),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: ClipperStyle(secondStyleUi),
                    child: Container(
                      color: primaryColor.withOpacity(0.7),
                      height: height * 25,
                      width: double.infinity,
                    ),
                  ),
                  if (secondStyleUi)
                    const Text(
                      TITLE_SUPPORTS,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        // fontFamily: 'Maginia',
                        // fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                ],
              ),
              ClipPath(
                clipper: ClipperStyle2(secondStyleUi),
                child: Container(
                  color: primaryColor.withOpacity(0.35),
                  height: height * 27.5,
                  width: double.infinity,
                ),
              ),
              if (secondStyleUi)
                ClipPath(
                  clipper: ClipperStyle3(secondStyleUi),
                  child: Container(
                    color: primaryColor.withOpacity(0.2),
                    height: height * 28.5,
                    width: double.infinity,
                  ),
                ),
              if (!secondStyleUi)
                Container(
                  height: height * 25,
                  padding: EdgeInsets.only(right: width * 2),
                  alignment: Alignment.bottomRight,
                  child: const Text(
                    TITLE_SUPPORTS,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                      // fontFamily: 'Maginia',
                      // fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                alignment:
                    secondStyleUi ? Alignment.topCenter : Alignment.topLeft,
                color: Colors.transparent,
                // height: deviceSize.height * 0.3,
                padding: EdgeInsets.only(
                    top: height, left: secondStyleUi ? 0 : width * 5),
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
                    height: height * 20,
                    width: height * 20,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: width * 3, right: width * 3),
                  height: height * 100 -
                      (MediaQuery.of(context).viewPadding.top +
                          appbar.preferredSize.height),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: SizedBox()),
                        getTextfieldContainer(
                          TITLE_NAME,
                          nameValidator,
                          TextFormField(
                            textAlignVertical: TextAlignVertical.top,
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
                            style: TextStyle(height: height / 5),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              Focus.of(context).nextFocus();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  nameValidator = true;
                                });
                                return TITLE_ENTER_NAME;
                              } else {
                                setState(() {
                                  nameValidator = false;
                                });
                                return null;
                              }
                            },
                            onSaved: (value) {
                              supportData['name'] = value!;
                            },
                          ),
                        ),
                        getTextfieldContainer(
                          TITLE_EMAIL,
                          emailValidator,
                          TextFormField(
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
                            style: TextStyle(height: height / 5),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              Focus.of(context).nextFocus();
                            },
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                setState(() {
                                  emailValidator = true;
                                });
                                return TITLE_INVALID_EMAIL;
                              } else {
                                setState(() {
                                  emailValidator = false;
                                });
                                return null;
                              }
                            },
                            onSaved: (value) {
                              supportData['email'] = value!;
                            },
                          ),
                        ),
                        const Text(
                          'Problem / Suggestion',
                          style: TextStyle(color: textInputTitleColor),
                        ),
                        SizedBox(
                          height: height,
                        ),
                        TextFormField(
                          maxLines: 5,
                          focusNode: FocusNode().enclosingScope,
                          decoration: InputDecoration(
                            focusColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return TITLE_ENTER_NAME;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            supportData['description'] = value!;
                          },
                        ),
                        SizedBox(
                          height: height,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 7,
                              width: width * 15,
                              child: ElevatedButton(
                                onPressed: _saveForm,
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
                                  TITLE_SUBMIT,
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
                          height: height,
                        )
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
