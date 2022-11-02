// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import '../provider/status.dart';
import '../provider/templates.dart';
import '../values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/tab_screen.dart';
import '/common_methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../values/app_routes.dart';
import '../provider/appointments.dart';
import '../values/strings_en.dart';

enum MoreOptions {
  Edit,
  Delete,
  Message,
  WhatsApp,
}

class AppointmentListTile extends StatefulWidget {
  final String type;
  // final Function? refresh;
  // final String? id;

  const AppointmentListTile({
    Key? key,
    required this.type,
    //  this.id,
    // this.refresh,
  }) : super(key: key);

  @override
  State<AppointmentListTile> createState() => _AppointmentListTileState();
}

class _AppointmentListTileState extends State<AppointmentListTile>
    with SingleTickerProviderStateMixin {
  late Appointment appointment;
  late Animation statusAnimation;
  late AnimationController animationController;
  // ValueNotifier<int> animationDuration = ValueNotifier(1);

  @override
  void initState() {
    // animationDuration.addListener(() {
    //   setState(() {});
    // });
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 50));

    statusAnimation =
        Tween<double>(begin: 1, end: 0.4).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    // CurvedAnimation(parent: animationController, curve: Curves.bounceIn);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  String templateFormate(
      {required Appointment appointment, required String newTemplate}) {
    newTemplate = newTemplate.replaceAll(
        RegExp(r'#name'), appointment.customer['full_name'].toString());
    newTemplate = newTemplate.replaceAll(
        '#dateTime',
        DateFormat('dd-MM-yyyy hh:mm a')
            .format(DateTime.parse(appointment.appointmentDate))
            .toString());
    return newTemplate;
  }

  _getSelectedTemplate() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('allTemlates');
    final slectedTemplateId = pref.getString('selectedTemplateId');
    final templateData = json.decode(data!);

    final template = templateData.firstWhere(
      (element) => element['id'] == slectedTemplateId,
      orElse: () {
        return templateData[0];
      },
    );
    return template;
  }

  @override
  Widget build(BuildContext context) {
    appointment = Provider.of<Appointment>(context);
    final statusList = Provider.of<StatusList>(context).status;

    var phoneNo =
        (appointment.customer['mobile_no']).toString().replaceAll(' ', '');

    String template =
        Provider.of<TemplateList>(context).selecetedTemplate.template!;
    if (phoneNo.length == 10) {
      phoneNo = '+91$phoneNo';
    }
    // templateFormate(appointment: appointment, newTemplate: template);
    Widget popmenu = PopupMenuButton(
      onSelected: (MoreOptions selectedValue) async {
        if (selectedValue == MoreOptions.Delete) {
          final response =
              await Provider.of<Appointments>(context, listen: false)
                  .deleteAppointment(appointment.id!, widget.type, context);

          if (response) {
            if (!mounted) return;
            displaySnackbar(context, TITLE_APPOINTMENT, TITLE_DELETED);
          }
        } else if (selectedValue == MoreOptions.Edit) {
          Navigator.of(context).pushNamed(
            APP_ROUTE_ADD_EDIT_APPOINTMENT,
            arguments: {'id': appointment.id},
          ).then(
            (value) async {
              if (value != null) {
                displaySnackbar(context, TITLE_APPOINTMENT, value);
                if (widget.type == 'recent') {
                  Navigator.of(context).pushReplacementNamed('/');
                } else if (widget.type != 'recent') {
                  final screenId = await getScreenValue();
                  if (!mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          TabScreen(screenId: int.parse(screenId!))));
                }
              }
            },
          );
        } else if (selectedValue == MoreOptions.Message) {
          // onPressed:
          final data = await _getSelectedTemplate();
          // print('data----->$data');
          template = templateFormate(
              appointment: appointment, newTemplate: data['template']);
          // print(data['template']);
          String url =
              "sms:${appointment.customer['mobile_no']}?body=$template";
          await canLaunchUrl(Uri.parse(url))
              ? launchUrl(Uri.parse(url))
              : const SnackBar(
                  content: Text('Can\'t Open Messenger'),
                );
        } else {
          final data = await _getSelectedTemplate();
          template = templateFormate(
              appointment: appointment, newTemplate: data['template']);
          // print(appointment.customer['mobile_no']);
          String url = "whatsapp://send?phone=$phoneNo&text=$template";
          await canLaunchUrl(Uri.parse(url))
              ? launchUrl(Uri.parse(url))
              : const SnackBar(
                  content: Text('Can\'t open whatsapp'),
                );
          //await snackBar(context, 'Can\'t open whatsapp');
          // print('Can\'t open whatsapp');
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
        const PopupMenuItem(
          value: MoreOptions.Message,
          child: Text(TITLE_MESSAGE),
        ),
        const PopupMenuItem(
          value: MoreOptions.WhatsApp,
          child: Text(TITLE_WHATSAPP),
        )
      ],
    );

    Future showStatusMenu(Offset offset, BuildContext context) async {
      //   print(appointment.servicesId);
      return await showMenu(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
          items: statusList
              .map((status) => PopupMenuItem(
                    child: Chip(
                      label: Text(
                        status.name,
                        style: const TextStyle(color: buttonTextColor),
                      ),
                      backgroundColor: statusColors(status.name),
                    ),
                    onTap: () async {
                      if (appointment.statusId == status.id) {
                        return;
                      }
                      var newStatusAppointment = Appointment(
                        customerId: appointment.customer['id'].toString(),
                        servicesId: appointment.servicesId,
                        appointmentDate: appointment.appointmentDate,
                        statusId: status.id,
                      );
                      log(widget.type);

                      animationController.repeat();
                      await Provider.of<Appointments>(context, listen: false)
                          .updateAppointment(appointment.id!,
                              newStatusAppointment, widget.type, context)
                          .then((value) {
                        if (value) {
                          animationController.animateBack(0);
                        }
                      });
                    },
                  ))
              .toList());
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, size: 40.0),
        title: Text(appointment.customer['full_name']),
        subtitle: Text(DateFormat('dd-MM-yyyy hh:mm a')
            .format(DateTime.parse(appointment.appointmentDate))
            .toString()),
        trailing: Consumer<Appointment>(
          builder: (ctx, _, child) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (deatails) {
                    // if (widget.refresh == null) {
                    //   return;
                    // }
                    // _isChangeStatusSelected = true;
                    final positionDetails = deatails.globalPosition;
                    showStatusMenu(positionDetails, context);
                  },
                  child: Opacity(
                    opacity: statusAnimation.value,
                    child: RawChip(
                        backgroundColor:
                            statusColors(appointment.status['name']),
                        onPressed: () {},
                        label: Text(
                          appointment.status['name'],
                          textScaleFactor: 0.71
                          // * statusAnimation.value
                          ,
                          style: const TextStyle(color: buttonTextColor),
                        )),
                  ),
                ),
                const Expanded(child: SizedBox()),
                popmenu,
              ],
            ),
          ),
        ),
        // onTap: () {
        //   Navigator.of(context).pushNamed(
        //     APP_ROUTE_APPOINTMENT_DETAIL,
        //     arguments: {'id': appointment.id},
        //   ).then((value) async {
        //     if (value == true) {
        //       if (widget.type == 'recent') {
        //         Navigator.of(context).pushReplacementNamed('/');
        //       } else if (widget.type != 'recent') {
        //         final screenId = await getScreenValue();
        //         {
        //           if (!mounted) return;

        //           Navigator.of(context).pushReplacement(MaterialPageRoute(
        //               builder: (ctx) =>
        //                   TabScreen(screenId: int.parse(screenId!))));
        //         }
        //       }
        //     }
        //   });
        // },
      ),
    );
  }
}
