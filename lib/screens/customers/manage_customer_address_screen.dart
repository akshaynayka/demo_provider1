// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, prefer_final_fields

import '../../common_methods/common_methods.dart';
import '../../provider/customer.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MoreOptions {
  Edit,
  Delete,
}

class ManageCustomerAddressScreen extends StatefulWidget {
  const ManageCustomerAddressScreen({Key? key}) : super(key: key);

  @override
  ManageCustomerAddressScreenState createState() =>
      ManageCustomerAddressScreenState();
}

class ManageCustomerAddressScreenState
    extends State<ManageCustomerAddressScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _radioValue1 = 0;
  var _addressArg;
  void _handleRadioValueChange1(int? value) {
    Provider.of<Customers>(context, listen: false)
        .dafaultCustomerAddress(
            _addressArg['id'].toString(), value.toString(), context)
        .then((value) async {
      await Provider.of<Customers>(context, listen: false)
          .fetchCustomerAddress(_addressArg['id'].toString());
    });
  }

  _deleteAddress(String customerId, String addressId, String isDefault) async {
    if (isDefault == 'yes') {
      showErrorDialog(
          TITLE_CANT_DELETE_ADDRESS + TITLE_MAKE_ANOTHER_ADDRESS_DEFAULT,
          context);
    } else {
      final response = await Provider.of<Customers>(context, listen: false)
          .deleteCustomerAddress(customerId, addressId, context);

     if (!mounted) return;   
      if (response) {
        displaySnackbar(context, TITLE_ADDRESS, TITLE_DELETED);
      }
    }
  }

  Future<void> _refreshCustomerAddressList() async {
    await Provider.of<Customers>(context, listen: false)
        .fetchCustomerAddress(_addressArg['id'].toString())
        .then((value) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _addressArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

      Provider.of<Customers>(context, listen: false)
          .fetchCustomerAddress(_addressArg['id'], context: context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final addressData = Provider.of<Customers>(context).customerAddressList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_MANAGE_ADDRESS),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text(TITLE_ADD_ADDRESS),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(APP_ROUTE_ADD_EDIT_CUSTOMER_ADDRESS, arguments: {
            'customerId': _addressArg['id'].toString(),
          }).then((value) {
            if (value != null && value != '') {
              _refreshCustomerAddressList();
              displaySnackbar(context, TITLE_ADDRESS, value);
            }
          });
        },
        elevation: 10,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : RefreshIndicator(
                onRefresh: () => _refreshCustomerAddressList(),
                child: ListView.builder(
                  itemCount: addressData.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChangeNotifierProvider.value(
                          value: addressData[index],
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(addressData[index].name),
                              subtitle: Text(addressData[index].mobileNo != null
                                  ? addressData[index].mobileNo!
                                  : ''),
                              leading: Radio(
                                value: int.parse(addressData[index].id!),
                                groupValue:
                                    addressData[index].defaultAddress == 'yes'
                                        ? int.parse(addressData[index].id!)
                                        : _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              trailing: PopupMenuButton(
                                onSelected: (MoreOptions selectedValue) async {
                                  if (selectedValue == MoreOptions.Delete) {
                                    _deleteAddress(
                                        _addressArg['id'].toString(),
                                        addressData[index].id!,
                                        addressData[index].defaultAddress!);
                                  } else {
                                    Navigator.of(context).pushNamed(
                                      APP_ROUTE_ADD_EDIT_CUSTOMER_ADDRESS,
                                      arguments: {
                                        'addressId': addressData[index].id,
                                        'customerId':
                                            _addressArg['id'].toString(),
                                      },
                                    ).then((value) {
                                      _refreshCustomerAddressList();
                                      displaySnackbar(
                                          context, TITLE_ADDRESS, value);
                                    });
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: MoreOptions.Edit,
                                    child: Text(TITLE_EDIT),
                                  ),
                                  const PopupMenuItem(
                                    value: MoreOptions.Delete,
                                    child: Text(TITLE_DELETE),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
      ),
    );
  }
}
