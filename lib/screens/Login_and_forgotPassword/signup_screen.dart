import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../model/http_exception.dart';
import '../../provider/auth.dart';
import '../../values/strings_en.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  const SignupScreen({Key? key}) : super(key: key);

  @override
   SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email']!,
        _authData['password']!,
      );
if (!mounted) return;   
      ///  route to app
      Navigator.of(context).pushReplacementNamed('/');
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This not valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'password is to weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not found email with that enail';
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.get('APP_TITLE')),
      ),
      body: SizedBox(
        height: deviceSize.height,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: deviceSize.height * 0.27,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: const [
                  SizedBox(
                    height: 25,
                  ),
                  Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                  Text(
                    TITLE_SIGNUP,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              top: deviceSize.height * 0.2,
              left: 10.0,
              right: 10.0,
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return TITLE_INVALID_EMAIL;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: TITLE_PASSWORD),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return TITLE_PASSWORD_IS_SHORT;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                          ),
                          TextFormField(
                              decoration: const InputDecoration(
                                  labelText: TITLE_CONFIRM_PASSWORD),
                              obscureText: true,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return TITLE_PASSWORD_NOT_MATCH;
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                textStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .button!
                                      .color,
                                ),
                              ),
                              child: const Text(TITLE_SIGNUP),
                            ),
                          TextButton(
                            child: const Text(TITLE_LOGIN),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
