import '../../provider/address.dart';
import '../../provider/customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../values/strings_en.dart';

class AddEditCustomerAddressScreen extends StatefulWidget {
  const AddEditCustomerAddressScreen({Key? key}) : super(key: key);

  @override
  AddEditCustomerAddressScreenState createState() =>
      AddEditCustomerAddressScreenState();
}

class AddEditCustomerAddressScreenState
    extends State<AddEditCustomerAddressScreen> {
  final _form = GlobalKey<FormState>();
  var _editedAddress = Address(
    id: null,
    name: '',
    mobileNo: '',
    addressLine1: '',
    addressLine2: '',
    landmark: '',
    countryId: '',
    stateId: '',
    cityId: '',
    pinCode: '',
  );

  var _initValues = {
    'name': '',
    'mobileNo': '',
    'addressLine1': '',
    'addressLine2': '',
    'landmark': '',
    'countryId': null,
    'stateId': null,
    'cityId': null,
    'pinCode': '',
  };

  var _isInit = true;
  var _isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var _addressArg;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AddressList>(context, listen: false)
          .fetchAllcountries(context: context);
      Provider.of<AddressList>(context, listen: false)
          .fetchAllStates(context: context);
      Provider.of<AddressList>(context, listen: false)
          .fetchAllCities(context: context);
      _addressArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

      if (_addressArg['addressId'] != null) {
        Provider.of<Customers>(context, listen: false)
            .fetchCustomerAddressById(
                _addressArg['customerId'], _addressArg['addressId'],
                context: context)
            .then((value) {
          _editedAddress = value;
          _initValues = {
            'name': value.name,
            'mobileNo': value.mobileNo,
            'addressLine1': value.addressLine1,
            'addressLine2': value.addressLine2,
            'landmark': value.landmark,
            'countryId': value.countryId,
            'stateId': value.stateId,
            'cityId': value.cityId,
            'pinCode': value.pinCode,
          };
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
    // _descriptionFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    var status = '';
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedAddress.id != null) {
      final response = await Provider.of<Customers>(context, listen: false)
          .updateCustomerAddress(_addressArg['customerId'], _editedAddress.id!,
              _editedAddress, context);
      if (response == true) {
        status = 'Updated';
      }
    } else {
      try {
        final response = await Provider.of<Customers>(context, listen: false)
            .addCustomerAddress(
                _addressArg['customerId'], _editedAddress, context);

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
                child: const Text(TITLE_OKAY),
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
    if (status != '') {}

    // for close the soft keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pop(status);
  }

  @override
  Widget build(BuildContext context) {
    final countriesList =
        Provider.of<AddressList>(context, listen: false).countriesList;
    final statesList =
        Provider.of<AddressList>(context, listen: false).statesList;
    final citiesList =
        Provider.of<AddressList>(context, listen: false).citiesList;

    final deviceSize = MediaQuery.of(context).size;
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
          : SizedBox(
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
                          Icons.location_city,
                          size: deviceSize.height * 0.0511,
                        ),
                        Text(
                          TITLE_ADDRESS,
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
                      key: _form,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          height: deviceSize.height * 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: _initValues['name'],
                                  decoration:
                                      const InputDecoration(labelText: TITLE_NAME),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_NAME;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: value!,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['mobileNo'],
                                  decoration:
                                      const InputDecoration(labelText: TITLE_MOBILE),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_MOBILE;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: value!,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['addressLine1'],
                                  decoration: const InputDecoration(
                                      labelText: TITLE_ADDRESSLINE1),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_ADDRESSLINE1;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: value,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['addressLine2'],
                                  decoration: const InputDecoration(
                                      labelText: TITLE_ADDRESSLINE2),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_ADDRESSLINE2;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: value!,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['landmark'],
                                  decoration: const InputDecoration(
                                      labelText: TITLE_LANDMARK),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_LANDMARK;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: value!,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  },
                                ),
                                DropdownButtonFormField(
                                  value: _initValues['countryId'],
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select $TITLE_COUNTRY!';
                                    }
                                    return null;
                                  },
                                  hint: const Text(TITLE_ENTER_COUNTRY),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  items: countriesList.map((item) {
                                    return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.name),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    // _initValues['countryId'] = val;
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: val as String,
                                      stateId: _editedAddress.stateId,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  }),
                                ),
                                DropdownButtonFormField(
                                  value: _initValues['stateId'],
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select $TITLE_STATE';
                                    }
                                    return null;
                                  },
                                  hint: const Text(TITLE_ENTER_STATE),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  items: statesList.map((item) {
                                    return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.name),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    // _initValues['countryId'] = val;
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: val as String,
                                      cityId: _editedAddress.cityId,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  }),
                                ),
                                DropdownButtonFormField(
                                  value: _initValues['cityId'],
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select $TITLE_CITY';
                                    }
                                    return null;
                                  },
                                  hint: const Text(TITLE_ENTER_CITY),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  items: citiesList.map((item) {
                                    return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.name),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    // _initValues['countryId'] = val;
                                    _editedAddress = Address(
                                      id: _editedAddress.id,
                                      name: _editedAddress.name,
                                      mobileNo: _editedAddress.mobileNo,
                                      addressLine1: _editedAddress.addressLine1,
                                      addressLine2: _editedAddress.addressLine2,
                                      landmark: _editedAddress.landmark,
                                      countryId: _editedAddress.countryId,
                                      stateId: _editedAddress.stateId,
                                      cityId: val as String,
                                      pinCode: _editedAddress.pinCode,
                                    );
                                  }),
                                ),
                                TextFormField(
                                  initialValue: _initValues['pinCode'],
                                  decoration:
                                      const InputDecoration(labelText: TITLE_PINCODE),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_PINCODE;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedAddress = Address(
                                        id: _editedAddress.id,
                                        name: _editedAddress.name,
                                        mobileNo: _editedAddress.mobileNo,
                                        addressLine1:
                                            _editedAddress.addressLine1,
                                        addressLine2:
                                            _editedAddress.addressLine2,
                                        landmark: _editedAddress.landmark,
                                        countryId: _editedAddress.countryId,
                                        stateId: _editedAddress.stateId,
                                        cityId: _editedAddress.cityId,
                                        pinCode: value!);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: deviceSize.height * 0.0639,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        onPressed: _saveForm,
                                        child: _editedAddress.id != null
                                            ? const Text(TITLE_UPDATE)
                                            : const Text(TITLE_ADD),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
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
