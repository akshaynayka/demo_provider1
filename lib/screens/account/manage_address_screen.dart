// ignore_for_file: constant_identifier_names


import '../../common_methods/common_methods.dart';
import '../../provider/address.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MoreOptions {
  Edit,
  Delete,
}

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({Key? key}) : super(key: key);

  @override
  ManageAddressScreenState createState() => ManageAddressScreenState();
}

class ManageAddressScreenState extends State<ManageAddressScreen> {
  var _isInit = true;
  var _isLoading = false;
  final _radioValue1 = 0;

  void _handleRadioValueChange(int? value) {
    Provider.of<AddressList>(context, listen: false)
        .dafaultAddress(value.toString(), context)
        .then((value) {
      Provider.of<AddressList>(context, listen: false).fetchAllAddress();
    });
  }

  @override
  void initState() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<AddressList>(context, listen: false)
          .fetchAllAddress(context: context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.initState();
  }

  _deleteAddress(String addressId, String isDefault) async {
    if (isDefault == 'yes') {
      showErrorDialog(
          TITLE_CANT_DELETE_ADDRESS + TITLE_MAKE_ANOTHER_ADDRESS_DEFAULT,
          context);
    } else {
      final response = await Provider.of<AddressList>(context, listen: false)
          .deleteAddress(addressId, context);

      if (response) {
        if (!mounted) return;
        displaySnackbar(context, TITLE_ADDRESS, TITLE_DELETED);
      }
    }
  }

  Future<void> _refreshAddressList() async {
    await Provider.of<AddressList>(context, listen: false)
        .fetchAllAddress(context: context)
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressData = Provider.of<AddressList>(context).addressList;
    bool nullAddress = addressData.isEmpty ? true : false;
    // log(nullAddress.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_MANAGE_ADDRESS),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text(TITLE_ADD_ADDRESS),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(APP_ROUTE_ADD_EDIT_ADDRESS)
              .then((value) {
            _refreshAddressList();
          });
        },
        elevation: 10,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshAddressList(),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : nullAddress
                  ? const Text('Address not found')
                  : ListView.builder(
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
                                  subtitle: Text(
                                      addressData[index].addressLine1 ?? ''),
                                  leading: Radio(
                                    value: int.parse(addressData[index].id!),
                                    groupValue:
                                        addressData[index].defaultAddress ==
                                                'yes'
                                            ? int.parse(addressData[index].id!)
                                            : _radioValue1,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  trailing: PopupMenuButton(
                                    onSelected:
                                        (MoreOptions selectedValue) async {
                                      if (selectedValue == MoreOptions.Delete) {
                                        _deleteAddress(addressData[index].id!,
                                            addressData[index].defaultAddress!);
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed(
                                          APP_ROUTE_ADD_EDIT_ADDRESS,
                                          arguments: nullAddress
                                              ? null
                                              : {'id': addressData[index].id},
                                        )
                                            .then((value) {
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
