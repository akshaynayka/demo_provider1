
import '../../values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../provider/appointments.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import '../../common_methods/common_methods.dart';

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails({Key? key}) : super(key: key);

  @override
  createState() => AppointmentDetailsState();
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;
  List<String> services = [];
  String selectedServices = '';
  Appointment? _appointmentData;

  // ignore: prefer_typing_uninitialized_variables

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _appointmentData = Provider.of<Appointment>(context);

      if (_appointmentData != null) {
        Provider.of<Appointments>(context, listen: false)
            .fetchAppointmentById(_appointmentData!.id!, context: context)
            .then((value) {
          _appointmentData = value;
          List temp = _appointmentData!.servicesId;
          for (var service in temp) {
            services.add(service['name']);
          }
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
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    ScrollController servicesScroller = ScrollController();

    Widget detailBox(
        {required String title, String? content, Widget? listdata}) {
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
          listdata ?? Text(content!, textScaleFactor: 1.05),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
      ),
      body: Builder(
        builder: (context) => SizedBox(
          height: deviceSize.height,
          child: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(_isEdit);
              return true;
            },
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
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
                            SizedBox(height: height * 2),
                            Column(
                              children: [
                                detailBox(
                                    title: TITLE_APPOINTMENT_NO,
                                    content: _appointmentData!.id!),
                                detailBox(
                                    title: TITLE_CUSTOMER_NAME,
                                    content: _appointmentData!
                                            .customer['full_name'] ??
                                        'Not Availble'),
                                detailBox(
                                  title: TITLE_SERVICES,
                                  listdata: SizedBox(
                                    height: services.length >= 3
                                        ? height * 20
                                        : services.length >= 2
                                            ? height * 13
                                            : height * 7,
                                    child: Scrollbar(
                                      controller: servicesScroller,
                                      interactive: true,
                                      radius: Radius.circular(height),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        controller: servicesScroller,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          alignment: Alignment.center,
                                          height: height * 5,
                                          margin: const EdgeInsets.all(5),
                                          padding: EdgeInsets.all(height),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 3)),
                                          child: Text(
                                            services[index],
                                            textScaleFactor: 1.05,
                                            style: const TextStyle(
                                                color: buttonTextColor),
                                          ),
                                        ),
                                        itemCount: services.length,
                                      ),
                                    ),
                                  ),
                                ),
                                detailBox(
                                  title: TITLE_DATE,
                                  content: DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(
                                      _appointmentData!.appointmentDate,
                                    ),
                                  ),
                                ),
                                detailBox(
                                  title: TITLE_TIME,
                                  content: DateFormat('hh:mm a').format(
                                    DateTime.parse(
                                      _appointmentData!.appointmentDate,
                                    ),
                                  ),
                                ),
                                detailBox(
                                  title: TITLE_STATUS,
                                  listdata: Container(
                                    padding: EdgeInsets.all(height * 1.5),
                                    decoration: BoxDecoration(
                                        color: statusColors(
                                            _appointmentData!.status['name']),
                                        borderRadius:
                                            BorderRadius.circular(height * 3)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _appointmentData!.status['name'],
                                          style: const TextStyle(
                                              color: buttonTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height,
                            )
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
                                width: MediaQuery.of(context).size.width * 0.22,
                                padding: EdgeInsets.only(top: height * 0.5),
                                child: Text(
                                  TITLE_APPOINTMENT,
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
                                              Theme.of(context).primaryColor,
                                        ),
                                        child: const Text(TITLE_MODIFY),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              APP_ROUTE_ADD_EDIT_APPOINTMENT,
                                              arguments: {
                                                'id': _appointmentData!.id
                                              }).then((value) {
                                            if (value != null) {
                                              Provider.of<Appointments>(context,
                                                      listen: false)
                                                  .fetchAppointmentById(
                                                      _appointmentData!.id!,
                                                      context: context)
                                                  .then((value) {
                                                _appointmentData = value;
                                                services = [];
                                                for (var service
                                                    in value.servicesId) {
                                                  services.add(service['name']);
                                                }

                                                setState(() {
                                                  _isEdit = true;
                                                });
                                              });
                                            }

                                            displaySnackbar(context,
                                                TITLE_APPOINTMENT, value);
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
