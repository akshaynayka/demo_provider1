import 'dart:developer';

import '../../values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../values/strings_en.dart';
import '../../values/app_routes.dart';
import '../../common_methods/common_methods.dart';

import '../../provider/services.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  ServiceDetailsState createState() => ServiceDetailsState();
}

class ServiceDetailsState extends State<ServiceDetails> {
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;
  // ignore: prefer_typing_uninitialized_variables
  Service? _serviceDetails;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _serviceDetails = Provider.of<Service>(context);
      if (_serviceDetails!.id != null) {
        // Provider.of<Services>(context, listen: false)
        //     .fetchServiceById(_serviceDetails!.id, context: context)
        //     .then((value) {
        //   _serviceDetails = value;

        setState(() {
          _isLoading = false;
        });
        // });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    //   if (_serviceArg != null) {
    // }
    _isInit = false;
    log('pop');
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
    // if (_serviceArg == null) {

    // }
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    Widget detailBox(
        {required String title, String? content, Widget? listData}) {
      return Container(
        padding: EdgeInsets.all(height),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: const TextStyle(
                color: textInputTitleColor, fontWeight: FontWeight.bold),
            textScaleFactor: 0.9,
          ),
          const Divider(
            height: 0,
          ),
          SizedBox(
            height: height,
          ),
          listData ??
              Text(
                content!,
                textScaleFactor: 1.05,
                style: TextStyle(
                  color: content == 'Active'
                      ? Colors.green
                      : (content == 'Inactive' ? Colors.red : null),
                ),
              ),
        ]),
      );
    }

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
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.all(15),
                        padding: EdgeInsets.only(
                            left: width * 1.5, right: width * 1.5),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        //  height: deviceSize.height * 0.6,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 4,
                            ),
                            detailBox(
                                title: TITLE_NAME,
                                content: _serviceDetails!.name),
                            detailBox(
                                title: TITLE_DESCRIPTION,
                                content: _serviceDetails!.description ?? ''),
                            detailBox(
                                title: TITLE_PRICE,
                                content: _serviceDetails!.price),
                            detailBox(
                                title: TITLE_STATUS,
                                content: _serviceDetails!.status),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(height),
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.14,
                                padding: EdgeInsets.only(top: height * 0.5),
                                child: Text(
                                  TITLE_SERVICE,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Container(
                                padding: EdgeInsets.only(
                                    left: width * 1.6, right: width * 1.6),
                                margin: EdgeInsets.all(height * width / 2),
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
                                              APP_ROUTE_ADD_EDIT_SERVICE,
                                              arguments: {
                                                'id': _serviceDetails!.id,
                                                // 'fromPage': 'details'
                                              }).then((value) async {
                                           
                                            log(value.toString());
                                            if (value != null && value != '') {
                                              Provider.of<Services>(context,
                                                      listen: false)
                                                  .fetchServiceById(
                                                      _serviceDetails!.id,
                                                      context: context)
                                                  .then((value) {
                                                _serviceDetails = value;
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
