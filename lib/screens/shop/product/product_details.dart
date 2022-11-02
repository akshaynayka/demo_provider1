// ignore_for_file: prefer_typing_uninitialized_variables

import '../../../provider/shop.dart';
import '../../../values/app_routes.dart';
import '../../../values/strings_en.dart';
import '../../../common_methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;
  var _productArg;
  late Product _productDetails;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _productArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      if (_productArg != null) {
        Provider.of<Shop>(context, listen: false)
            .fetchProductById(_productArg['id'], context: context)
            .then((value) {
          _productDetails = value;

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

  Widget tableTextLeft(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        value,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget tableTextRight(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15),
      child: Text(
        value,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_isEdit);

          return true;
        },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Builder(
                builder: (context) => SizedBox(
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
                              height: deviceSize.height * 0.03197,
                            ),
                            Icon(
                              Icons.shop_two,
                              size: deviceSize.height * 0.05116,
                            ),
                            Text(
                              TITLE_PRODUCT,
                              style: TextStyle(
                                fontSize: deviceSize.height * 0.03837,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: deviceSize.height * 0.164,
                        left: 10.0,
                        right: 10.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 8,
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: deviceSize.height * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        tableTextLeft(TITLE_NAME),
                                        tableTextRight(_productDetails.name),
                                      ]),
                                      TableRow(children: [
                                        tableTextLeft(TITLE_DESCRIPTION),
                                        tableTextRight(
                                            _productDetails.description != null
                                                ? _productDetails.description!
                                                : '')
                                      ]),
                                      TableRow(children: [
                                        tableTextLeft(TITLE_STATUS),
                                        tableTextRight(_productDetails.status),
                                      ]),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  child: const Text(TITLE_EDIT),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        APP_ROUTE_ADD_EDIT_PRODUCT,
                                        arguments: {
                                          'id': _productDetails.id,
                                          // 'fromPage': 'details'
                                        }).then((value) {
                                      if (value != null && value != '') {
                                        Provider.of<Shop>(context,
                                                listen: false)
                                            .fetchProductById(_productArg['id'],
                                                context: context)
                                            .then((value) {
                                          _productDetails = value;

                                          setState(() {
                                            _isEdit = true;
                                          });
                                        });
                                      }
                                      displaySnackbar(
                                          context, TITLE_SERVICE, value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
