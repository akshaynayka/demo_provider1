import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
      ),
      body:
          //  _isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          SizedBox(
        height: deviceSize.height,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: deviceSize.height * 0.27,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.0319,
                  ),
                  Icon(
                    Icons.person,
                    size: deviceSize.height * 0.0511,
                  ),
                  Text(
                    TITLE_CHANGE_PASSWORD,
                    style: TextStyle(
                      fontSize: deviceSize.height * 0.0383,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: deviceSize.height * 0.164,
              left: 10.0,
              right: 10.0,
              child: Form(
                // key: _form,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: deviceSize.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            // initialValue: _initValues['full_name'],
                            decoration: const InputDecoration(
                                labelText: TITLE_CURRENT_PASSWORD),
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context)
                            //       .requestFocus(_mobileNumberFocusNode);
                            // },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_ENTER_CURRENT_PASSWORD;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _editedCustomer = Customer(
                              //   id: _editedCustomer.id,
                              //   fullName: value,
                              //   mobileNo: _editedCustomer.mobileNo,
                              //   email: _editedCustomer.email,
                              //   dob: _editedCustomer.dob,
                              //   gender: _editedCustomer.gender,
                              //   whatsapp: _editedCustomer.whatsapp,
                              //   favorite: _editedCustomer.favorite,
                              //   status: _editedCustomer.status,
                              // );
                            },
                          ),
                          TextFormField(
                            // initialValue: _initValues['full_name'],
                            decoration:
                                const InputDecoration(labelText: TITLE_NEW_PASSWORD),
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context)
                            //       .requestFocus(_mobileNumberFocusNode);
                            // },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_ENTER_NEW_PASSWORD;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _editedCustomer = Customer(
                              //   id: _editedCustomer.id,
                              //   fullName: value,
                              //   mobileNo: _editedCustomer.mobileNo,
                              //   email: _editedCustomer.email,
                              //   dob: _editedCustomer.dob,
                              //   gender: _editedCustomer.gender,
                              //   whatsapp: _editedCustomer.whatsapp,
                              //   favorite: _editedCustomer.favorite,
                              //   status: _editedCustomer.status,
                              // );
                            },
                          ),
                          TextFormField(
                            // initialValue: _initValues['full_name'],
                            decoration: const InputDecoration(
                                labelText: TITLE_CONFIRM_PASSWORD),
                            textInputAction: TextInputAction.next,
                   
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_CONFIRM_YOUR_PASSWORD;
                              }
                              return null;
                            },
         
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: deviceSize.height * 0.0639,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  child: const Text(TITLE_CHANGE_PASSWORD),
                                  // onPressed: _saveForm,
                                  onPressed: () {},
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  child: const Text(TITLE_CANCEL),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
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
          ],
        ),
      ),
    );
  }
}
