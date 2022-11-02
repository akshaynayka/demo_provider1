import '../../provider/templates.dart';
import '../../values/app_colors.dart';
import '../../values/strings_en.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditTemplateScreen extends StatefulWidget {
  const AddEditTemplateScreen({Key? key}) : super(key: key);

  @override
  State<AddEditTemplateScreen> createState() => _AddEditTemplateScreenState();
}

class _AddEditTemplateScreenState extends State<AddEditTemplateScreen> {
  var templateTextControllar = TextEditingController();
  bool _init = true;
  bool _isNew = false;
  String? id;
  Template savedTemplate = Template(id: null, template: '');

  @override
  void didChangeDependencies() async {
    if (_init) {
      id = ModalRoute.of(context)!.settings.arguments as String?;

      if (id != null) {
        final retrivedTemplate =
            await Provider.of<TemplateList>(context, listen: false)
                .fetchTemplateById(id: id!);
        templateTextControllar.text = retrivedTemplate.template!;
      } else {
        _isNew = true;
      }
    }

    templateTextControllar.addListener(() {
      setState(() {});
    });

    _init = false;

    super.didChangeDependencies();
  }

  saveTemplate() async {
    var status = '';
    if (templateTextControllar.text.isEmpty) {
      return;
    } else {
      savedTemplate = Template(id: id, template: templateTextControllar.text);

      try {
        if (_isNew) {
          await Provider.of<TemplateList>(context, listen: false)
              .addTemplate(savedTemplate, context);
          status = 'Added';
        } else {
          await Provider.of<TemplateList>(context, listen: false)
              .updateTemplate(id!, savedTemplate, context);
          status = 'Updated';
        }
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
        // rethrow;
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
    if (!mounted) return;   
    await Provider.of<TemplateList>(context, listen: false)
        .fetchAllTemplateList(context: context);
    // for close the soft keyboard
    if (!mounted) return;   
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop(status);
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = ['#name', '#dateTime'];
    Size deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Template'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                margin: const EdgeInsets.all(15),
                padding: EdgeInsets.only(left: width * 1.5, right: width * 1.5),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 2,
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(height * 0.5),
                                child: Text('All Keys',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                              SizedBox(
                                // height: height*10,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: width * 10,
                                          childAspectRatio: 4 / 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemBuilder: (context, index) {
                                    return Chip(
                                      label: FittedBox(
                                        child: Text(keys[index],
                                            style: const TextStyle(
                                                color: buttonTextColor)),
                                      ),
                                      backgroundColor: templateTextControllar
                                              .text
                                              .contains(keys[index])
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    );
                                  },
                                  itemCount: keys.length,
                                ),
                              )
                            ]),
                      ),
                    ),
                    Card(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              const Text('Template'),
                              TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                controller: templateTextControllar,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      //  padding:
                      //   EdgeInsets.only(left: width * 1.6, right: width * 1.6),
                      margin: EdgeInsets.all(height * width / 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {
                                await saveTemplate();
                              },
                              child: Text(
                                _isNew ? TITLE_ADD : TITLE_UPDATE,
                              ),
                              // onPressed: () {
                              //   Navigator.of(context).pushNamed(
                              //       APP_ROUTE_ADD_EDIT_APPOINTMENT,
                              //       arguments: {
                              //         'id': _appointmentData!.id
                              //       }).then((value) {
                              //     if (value != null) {
                              //       Provider.of<Appointments>(context,
                              //               listen: false)
                              //           .fetchAppointmentById(_serviceArg['id'],
                              //               context: context)
                              //           .then((value) {
                              //         _appointmentData = value;
                              //         setState(() {
                              //           _isEdit = true;
                              //         });
                              //       });
                              //     }

                              //     displaySnackbar(
                              //         context, TITLE_APPOINTMENT, value);
                              //   });
                              // },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * .8,
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
                          TITLE_TEMPLATE,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      // const Expanded(child: SizedBox()),
                      // Container(
                      //   padding:
                      //       EdgeInsets.only(left: width * 1.6, right: width * 1.6),
                      //   margin: EdgeInsets.all(height * width / 2),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             primary: Theme.of(context).primaryColor,
                      //           ),
                      //           onPressed: () async {
                      //             await saveTemplate();
                      //           },
                      //           child: Text(
                      //             _isNew ? TITLE_ADD : TITLE_MODIFY,
                      //           ),
                      //           // onPressed: () {
                      //           //   Navigator.of(context).pushNamed(
                      //           //       APP_ROUTE_ADD_EDIT_APPOINTMENT,
                      //           //       arguments: {
                      //           //         'id': _appointmentData!.id
                      //           //       }).then((value) {
                      //           //     if (value != null) {
                      //           //       Provider.of<Appointments>(context,
                      //           //               listen: false)
                      //           //           .fetchAppointmentById(_serviceArg['id'],
                      //           //               context: context)
                      //           //           .then((value) {
                      //           //         _appointmentData = value;
                      //           //         setState(() {
                      //           //           _isEdit = true;
                      //           //         });
                      //           //       });
                      //           //     }

                      //           //     displaySnackbar(
                      //           //         context, TITLE_APPOINTMENT, value);
                      //           //   });
                      //           // },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
