import '../../values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../provider/customer.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import '../../common_methods/common_methods.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  CustomerDetailsState createState() => CustomerDetailsState();
}

class CustomerDetailsState extends State<CustomerDetails> {
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;
  // ignore: prefer_typing_uninitialized_variables

  Customer? _customerDetails;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _customerDetails = Provider.of<Customer>(context);
      if (_customerDetails != null) {
        Provider.of<Customers>(context, listen: false)
            .fetchCustomerById(_customerDetails!.id, context: context)
            .then((value) {
          _customerDetails = value;

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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double h = deviceSize.height * 0.01;
    double w = deviceSize.width * 0.02;

    Widget detailBox(
        {required String title, String? content, Widget? listData}) {
      return Container(
        padding: EdgeInsets.all(h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: textInputTitleColor,
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 0.9,
            ),
            const Divider(
              height: 0,
            ),
            SizedBox(
              height: h,
            ),
            listData ??
                Text(
                  content!,
                  textScaleFactor: 1.05,
                  style: TextStyle(
                    color: content == 'Active' ||
                            content == 'Available' ||
                            content == 'Favorite'
                        ? Colors.green
                        : (content == 'Inactive' ||
                                content == 'Not Favorite' ||
                                content == 'Not Available'
                            ? Colors.red
                            : null),
                  ),
                ),
            SizedBox(
              height: h,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.get('APP_TITLE')),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // log(_isEdit.toString());
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
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.all(15),
                        padding: EdgeInsets.only(left: w * 1.5, right: w * 1.5),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: h * 4,
                          ),
                          detailBox(
                              title: TITLE_NAME,
                              content: _customerDetails!.fullName),
                          detailBox(
                              title: TITLE_MOBILE,
                              content: _customerDetails!.mobileNo),
                          if (_customerDetails?.email != null)
                            detailBox(
                                title: TITLE_EMAIL,
                                content: _customerDetails!.email),
                          detailBox(
                              title: TITLE_WHATSAPP,
                              content: _customerDetails!.whatsapp == 'yes'
                                  ? TITLE_AVAILABLE
                                  : TITLE_NOT_AVAILABLE),
                          detailBox(
                              title: TITLE_BIRTH_DATE,
                              content: _customerDetails!.dob != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(_customerDetails!.dob!),
                                    )
                                  : TITLE_NOT_AVAILABLE),
                          detailBox(
                              title: TITLE_STATUS,
                              content: _customerDetails!.status),
                          detailBox(
                              title: TITLE_FAVORITE,
                              content: _customerDetails!.favorite == 'yes'
                                  ? TITLE_FAVORITE
                                  : TITLE_NOT_FAVORITE),
                        ]),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(h),
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.22,
                                padding: EdgeInsets.only(top: h * 0.5),
                                child: Text(
                                  TITLE_CUSTOMER,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Container(
                                padding: EdgeInsets.only(
                                    left: w * 1.6, right: w * 1.6),
                                margin: EdgeInsets.all(h * w / 2),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        child: const Text(TITLE_MODIFY),
                                        onPressed: () async {
                                          await Navigator.of(context).pushNamed(
                                              APP_ROUTE_ADD_EDIT_CUSTOMER,
                                              arguments: {
                                                'id': _customerDetails!.id
                                              }).then((value) {
                                            if (value != null && value != '') {
                                              Provider.of<Customers>(context,
                                                      listen: false)
                                                  .fetchCustomerById(
                                                      _customerDetails!.id,
                                                      context: context)
                                                  .then((value) {
                                                _customerDetails = value;

                                                setState(() {
                                                  _isEdit = true;
                                                });
                                              });
                                            }

                                            displaySnackbar(
                                                context, TITLE_CUSTOMER, value);
                                          });
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
