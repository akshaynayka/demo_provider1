// ignore_for_file: prefer_final_fields
import '../../values/app_colors.dart';

import '../../provider/appointments.dart';
import '../../provider/status.dart';
import '../../screens/appointments/customer_dropdown_search.dart';
import '../../screens/appointments/service_search_dropdown.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddEditAppointmentScreen extends StatefulWidget {
  const AddEditAppointmentScreen({Key? key}) : super(key: key);
  @override
  AddEditAppointmentScreenState createState() =>
      AddEditAppointmentScreenState();
}

class AddEditAppointmentScreenState extends State<AddEditAppointmentScreen> {
  StepperType stepperType = StepperType.horizontal;

  TextEditingController _selectedCustomerController = TextEditingController();
  TextEditingController _datePickerController = TextEditingController();
  TextEditingController _timePickerController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  //TextEditingController _selectedServiceController = TextEditingController();
  ScrollController _servicesScrollController = ScrollController();
  List<dynamic>? _selectedServiceList;
  bool servicesValidation = false;
  final _form = GlobalKey<FormState>();
  // final _form1 = GlobalKey<FormState>();
  // final _form2 = GlobalKey<FormState>();

  Map<String, dynamic> _appointmentData = {
    'id': null,
    'customerId': '',
    'serviceId': '',
    'statusId': '1',
  };

  var _isInit = true;
  var _isLoading = false;
  var _isNew = false;

  @override
  void didChangeDependencies() {
    //  print('didchange');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<StatusList>(context, listen: false)
          .fetchAllStatus(context: context);

      final appointmentId =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;

      if (appointmentId != null) {
        Provider.of<Appointments>(context, listen: false)
            .fetchAppointmentById(appointmentId['id']!)
            .then((value) {
          _appointmentData = {
            'id': value.id,
            'customerId': value.customerId,
            'serviceId': value.servicesId,
            'statusId': value.statusId,
          };

          _selectedServiceList = value.servicesId;
          _selectedDateTime = DateTime.parse(value.appointmentDate);

          _selectedCustomerController.text = value.customer['full_name'];

          _datePickerController.text = DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(value.appointmentDate))
              .toString();

          _timePickerController.text = DateFormat('hh:mm a')
              .format(DateTime.parse(value.appointmentDate))
              .toString();

          setState(() {
            _isLoading = false;
          });
        });
      } else {
        _isNew = true;
        var initialDateTime = _setInitialDateTime();
        _timePickerController.text =
            DateFormat('hh:mm a').format(initialDateTime);
        _datePickerController.text =
            DateFormat('dd-MM-yyyy').format(initialDateTime);
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void showServiceBottomSheet(BuildContext ctx, serviceList) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: ServiceSearchDropdown(
              callback: (val) => setState(() {
                    _selectedServiceList = val;
                    if (_selectedServiceList!.isNotEmpty) {
                      servicesValidation = false;
                    }
                  }),
              serviceList: serviceList),
        );
      },
    );
  }

  void showCustomerBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: CustomerSearchDropdown(
                callback: (val) => setState(() {
                      _appointmentData['customerId'] = val.id;
                      _selectedCustomerController.text = val.fullName;
                    })),
          ),
        );
      },
    );
  }

  DateTime _setInitialDateTime() {
    var minute00 = DateFormat('m').format(_selectedDateTime);
    var totalMinute = int.parse(minute00) + 30;
    var roundedMinute = 0;
    if (totalMinute > 60) {
      roundedMinute = 30;
    }
    var calculatedTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        _selectedDateTime.hour,
        roundedMinute,
        _selectedDateTime.second,
        _selectedDateTime.millisecond,
        _selectedDateTime.microsecond);
    _selectedDateTime = calculatedTime.add(const Duration(minutes: 60));
    return _selectedDateTime;
  }

  _presentDatePicker({String? date}) {
    var initialDate = DateTime.now();

    if (date != '') {
      initialDate = DateTime.parse(date!);
    }
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        final selectedDate = pickedDate;
        _datePickerController.text =
            DateFormat('dd-MM-yyyy').format(selectedDate);
        _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            _selectedDateTime.hour,
            _selectedDateTime.minute,
            _selectedDateTime.second,
            _selectedDateTime.millisecond,
            _selectedDateTime.microsecond);
      });
    });
  }

  _presentTimePicker(String dateTime) async {
    var hour = DateFormat('H').format(_selectedDateTime);
    var minute = DateFormat('m').format(_selectedDateTime);
    if (dateTime == '') {
    } else {
      hour = DateFormat('H').format(DateTime.parse(dateTime)).toString();
      minute = DateFormat('m').format(DateTime.parse(dateTime)).toString();
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(hour), minute: int.parse(minute)),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
            _selectedDateTime.second,
            _selectedDateTime.millisecond,
            _selectedDateTime.microsecond);
        _timePickerController.text =
            DateFormat('hh:mm:aa').format(_selectedDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusList = Provider.of<StatusList>(context, listen: false).status;
    final devicesize = MediaQuery.of(context).size;
    double h = devicesize.height * 0.01;
    double w = devicesize.width * 0.02;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.84,
                    margin: EdgeInsets.all(w * 1.2),
                    padding: EdgeInsets.all(h * 0.9),
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
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: w, right: w, top: h, bottom: h),
                            // padding: EdgeInsets.only(left: w, right: w, top: h),
                            // height: h * 30,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Customer'),
                                  controller: _selectedCustomerController,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Select Customer';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () {
                                    showCustomerBottomSheet(context);
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: TITLE_DATE),
                                  textInputAction: TextInputAction.next,
                                  controller: _datePickerController,
                                  onTap: () {
                                    _presentDatePicker(date: '');
                                  },
                                  readOnly: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter $TITLE_DATE';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: TITLE_TIME),
                                  controller: _timePickerController,
                                  onTap: () {
                                    _presentTimePicker('');
                                  },
                                  readOnly: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter $TITLE_TIME';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                              ],
                            ),
                          ),
                          Card(
                            // elevation: 0,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showServiceBottomSheet(
                                        context, _selectedServiceList);
                                  },
                                  child: SizedBox(
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(width: 1)),
                                    height: MediaQuery.of(context).size.height *
                                        0.06,

                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: w * 2.2),
                                          child: Text(
                                            TITLE_SELECT_SERVICES,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            padding:
                                                EdgeInsets.only(right: w * 2.5),
                                            child: Icon(Icons.search_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                if (servicesValidation)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: w * 2, top: h, bottom: h),
                                        child: const Text(
                                            'Select At Least one Service',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                if (_selectedServiceList != null &&
                                    _selectedServiceList!.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.all(w * 0.8),
                                    height: MediaQuery.of(context).size.height *
                                        (_selectedServiceList!.length <= 1
                                            ? 0.0755
                                            : _selectedServiceList!.length <= 2
                                                ? 0.16
                                                : 0.236),
                                    child: Scrollbar(
                                      interactive: true,
                                      controller: _servicesScrollController,
                                      scrollbarOrientation:
                                          ScrollbarOrientation.left,
                                      radius: Radius.circular(h),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        controller: _servicesScrollController,
                                        itemCount: _selectedServiceList!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.all(h * 0.6),
                                            padding: EdgeInsets.all(h * 1.2),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                            ),
                                            height: h * 6.5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _selectedServiceList![index]
                                                        ['name'],
                                                    style: const TextStyle(
                                                        color: buttonTextColor),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedServiceList!
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .remove_circle_rounded,
                                                      color: Colors.white,
                                                      size: h * h,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Card(
                              //elevation: 0,
                              child: Column(
                            children: [
                              const Text(TITLE_STATUS),
                              const Divider(
                                height: 0,
                              ),
                              SizedBox(
                                height: h * 6.5,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(w * 0.5),
                                        child: ChoiceChip(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          selectedColor: statusColors(
                                              statusList[index].name),
                                          backgroundColor: Colors.grey[300],
                                          label: Text(
                                            statusList[index].name,
                                            style: const TextStyle(
                                                color: buttonTextColor),
                                          ),
                                          selected:
                                              _appointmentData['statusId'] ==
                                                  statusList[index].id,
                                          onSelected: (_) {
                                            setState(() {
                                              _appointmentData['statusId'] =
                                                  statusList[index].id;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.55,
                                      ),
                                    ],
                                  ),
                                  itemCount: statusList.length,
                                ),
                              ),
                            ],
                          )),
                          const Expanded(child: SizedBox()),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: w * 0.6, right: w * 0.6),
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
                                    child: Text(_isNew ? 'Add' : 'Update'),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
                        TITLE_APPOINTMENT,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _saveForm() async {
    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (!_form.currentState!.validate() && _selectedServiceList == null) {
      setState(() {
        servicesValidation = true;
      });
      return;
    }
    if (_appointmentData['id'] != null) {
      final response = await Provider.of<Appointments>(context, listen: false)
          .updateAppointment(
              _appointmentData['id'],
              Appointment(
                customerId: _appointmentData['customerId'],
                appointmentDate: _selectedDateTime.toIso8601String(),
                servicesId: _selectedServiceList,
                statusId: _appointmentData['statusId'],
              ),
              'all',
              context);
      if (response == true) {
        status = 'Updated';
      }
    } else {
      try {
        final response = await Provider.of<Appointments>(context, listen: false)
            .addAppointment(
                Appointment(
                  customerId: _appointmentData['customerId'],
                  appointmentDate: _selectedDateTime.toIso8601String(),
                  servicesId: _selectedServiceList,
                  statusId: _appointmentData['statusId'],
                ),
                context);

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
    {
      if (!mounted) return;

      // for close the soft keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop(status);
    }
  }
}
