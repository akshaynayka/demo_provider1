import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../provider/customer.dart';
import '../../values/strings_en.dart';

class AddEditCustomerScreen extends StatefulWidget {
  const AddEditCustomerScreen({Key? key}) : super(key: key);

  @override
  AddEditCustomerScreenState createState() => AddEditCustomerScreenState();
}

class AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _mobileNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCustomer = Customer(
    id: null,
    fullName: '',
    mobileNo: '',
    email: '',
    dob: '',
    gender: 'female',
    whatsapp: 'no',
    favorite: 'no',
    status: 'Active',
  );
  DateTime? _birthDate;
  // ignore: prefer_final_fields
  TextEditingController _birthDateController = TextEditingController();
  Map<String?, String?> _initValues = {
    'full_name': '',
    'mobile_no': '',
    'email': '',
    'dob': '',
    'gender': '',
    'whatsapp': 'no',
    'favorite': 'no',
    'status': 'Active',
  };

  var _isInit = true;
  var _isLoading = false;
  var _isFavorite = false;
  var _isWhatsapp = false;
  // ignore: prefer_typing_uninitialized_variables
  var _customerArg;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _customerArg = ModalRoute.of(context)!.settings.arguments;
      if (_customerArg != null) {
        Provider.of<Customers>(context, listen: false)
            .fetchCustomerById(_customerArg['id'], context: context)
            .then((value) {
          _editedCustomer = value;
          _initValues = {
            'full_name': value.fullName,
            'mobile_no': value.mobileNo,
            'email': value.email,
            'dob': value.dob,
            'gender': value.gender,
            'whatsapp': value.whatsapp,
            'favorite': value.favorite,
            'status': value.status,
          };
          _isFavorite = _initValues['favorite'] == 'yes' ? true : false;

          _isFavorite = _initValues['favorite'] == 'yes' ? true : false;
          _isWhatsapp = _initValues['whatsapp'] == 'yes' ? true : false;
          _birthDateController.text = _editedCustomer.dob != null
              ? DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(_editedCustomer.dob!))
                  .toString()
              : '';
          _birthDate = _editedCustomer.dob != null
              ? DateTime.parse(_editedCustomer.dob!)
              : null;

          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mobileNumberFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    // ignore: prefer_typing_uninitialized_variables
    var status;

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
   // print(_editedCustomer.dob);
    setState(() {
      _isLoading = true;
    });

    if (_editedCustomer.id != null) {
      final response = await Provider.of<Customers>(context, listen: false)
          .updateCustomer(_editedCustomer.id, _editedCustomer, context);
      if (response == true) {
        status = 'Updated';
      }
    } else {
      try {
        final response = await Provider.of<Customers>(context, listen: false)
            .addCustomer(_editedCustomer, context);
        if (response == true) {
          status = 'Added';
        }
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(TITLE_ERROR_OCCURED),
            content: const Text(TITLE_ERROR_WENT_WRONG),
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
    }

    setState(() {
      _isLoading = false;
    });

    // for close the soft keyboard
    if (!mounted) return;
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop(status);
  }

  _presentDatePicker(String? date) {
    showDatePicker(
      context: context,
      initialDate: date == '' || date == null || date == 'null'
          ? DateTime.now()
          : DateTime.parse(date),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _birthDate = pickedDate;
        _birthDateController.text =
            DateFormat('yyyy-MM-dd').format(_birthDate!).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double h = deviceSize.height * 0.01;
    double w = deviceSize.width * 0.02;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.841,
                    margin: EdgeInsets.all(w * 1.5),
                    padding: EdgeInsets.all(w * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: _initValues['full_name'],
                            decoration:
                                const InputDecoration(labelText: TITLE_NAME),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_mobileNumberFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_ENTER_NAME;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedCustomer.fullName = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['mobile_no'],
                            decoration:
                                const InputDecoration(labelText: TITLE_MOBILE),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _mobileNumberFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_ENTER_MOBILE;
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedCustomer.mobileNo = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['email'],
                            decoration:
                                const InputDecoration(labelText: TITLE_EMAIL),
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocusNode,
                            validator: (value) {
                              if (value!.isEmpty && !value.contains('@')) {
                                return TITLE_ENTER_EMAIL;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_addressFocusNode);
                            },
                            onSaved: (value) {
                              _editedCustomer.email =
                                  value!.isEmpty ? '' : value;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_month_rounded),
                                labelText: TITLE_BIRTH_DATE),
                            controller: _birthDateController,
                            onTap: () {
                              _presentDatePicker(_birthDate.toString());
                            },
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return TITLE_ENTER_BIRTHDATE;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedCustomer.dob = _birthDate!.toIso8601String().toString();
                            },
                          ),
                          SizedBox(
                            height: h,
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      // w * 18,
                                      w * 15.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'WhatsApp',
                                        textScaleFactor: 1.01,
                                      ),
                                      Checkbox(
                                        value: _isWhatsapp,
                                        onChanged: (value) {
                                          setState(() {
                                            _isWhatsapp = value!;
                                          });
                                          _editedCustomer.whatsapp =
                                              _isWhatsapp ? 'yes' : 'no';
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                SizedBox(
                                  width:
                                      //w * 16,
                                      w * 13.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'Favorite',
                                        textScaleFactor: 1.01,
                                      ),
                                      Checkbox(
                                        value: _isFavorite,
                                        onChanged: (value) {
                                          setState(() {
                                            _isFavorite = value!;
                                          });
                                          _editedCustomer.favorite =
                                              _isFavorite ? 'yes' : 'no';
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: w * 14.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _editedCustomer.status,
                                        style: TextStyle(
                                            color: _editedCustomer.status ==
                                                    'Active'
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      Switch(
                                          value: _editedCustomer.status ==
                                              'Active',
                                          onChanged: (_) {
                                            setState(() {
                                              if (_editedCustomer.status ==
                                                  'Active') {
                                                _editedCustomer.status =
                                                    'Inactive';
                                              } else {
                                                _editedCustomer.status =
                                                    'Active';
                                              }
                                            });
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _saveForm();
                                  },
                                  child: Text(_editedCustomer.id == null
                                      ? 'Add'
                                      : 'Modify'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height * 0.05,
                    padding: EdgeInsets.only(bottom: h * 1.5),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: Text(
                          TITLE_CUSTOMER,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
