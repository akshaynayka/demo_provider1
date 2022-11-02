import 'dart:convert';

import '../../common_methods/common_methods.dart';
import '../../provider/templates.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  @override
  void initState() {
    _getTemplate();
    super.initState();
  }

  _getTemplate() async {
    setState(() {
      _isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('allTemlates');
    _slectedTemplateId = pref.getString('selectedTemplateId');
    final templateData = json.decode(data!);
    templateData.forEach((templateData) {
      allTemplates.add(
        Template(
          id: templateData['id'].toString(),
          template: templateData['template'],
        ),
      );
    });

    for (var element in allTemplates) {
      counter++;
      list.add(
        NavigationRailDestination(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.padding_outlined,
              ),
              Text(counter.toString())
            ],
          ),
          label: Text('Template ${element.id!}'),
          selectedIcon: const Icon(Icons.padding_rounded),
        ),
      );
    }
    // slectedTemplateId
    // final temp1 = allTemplates.where((template) {
    //   return template.id == slectedTemplateId ? true : false;
    // });

    // selectedTemplate = allTemplates.firstWhere(
    //   (element) => element.id == slectedTemplateId,
    //   orElse: () {
    //     return Template(id: null, template: null);
    //   },
    // );

    // Find the index of person. If not found, index = -1
    final index = allTemplates.indexWhere(
      (element) => element.id == _slectedTemplateId,
    );
    if (index >= 0) {
      _selectedindex = index;
    }
    // print('slectedTemplateId--->$_selectedindex');

    // selectedTemplate =
    // Provider.of<TemplateList>(context, listen: false).selecetedTemplate;

    // print('selected template--->${selectedTemplate.id}');

    setState(() {
      _isLoading = false;
    });
  }

  // List<Template> _allTemplates = [];
  List<Template> allTemplates = [];
  // Template selectedTemplate = Template(id: null, template: null);
// int selectedTemplateId = 0;
  // ignore: prefer_typing_uninitialized_variables
  var _slectedTemplateId;
  int counter = 0;
  int _selectedindex = 0;
  // ignore: unused_field
  bool _currentTemplate = false;
  String? id = '';
  // Template selectedTemplate =
  //     Template(id: '', template: TITLE_TEMPLATE_DEFAULT);
  bool _isLoading = true;

  List<NavigationRailDestination> list = [];
  String templateFormate(String newTemplate) {
    newTemplate = newTemplate.replaceAll(RegExp(r'#name'), 'demo1');
    newTemplate = newTemplate.replaceAll('#dateTime', '14-04-2022 01:30 PM');
    return newTemplate;
  }

  // @override
  // void didChangeDependencies() async {
  //   if (_init == false) {
  //     // _allTemplates =
  //     //     Provider.of<TemplateList>(context, listen: false).allTemplates;
  //     // _isLoading = false;
  //     // allTemplates = _allTemplates;
  //     // print('leng  ${allTemplates.length}');

  //     for (var element in allTemplates) {
  //       counter++;
  //       list.add(
  //         NavigationRailDestination(
  //           icon: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               const Icon(
  //                 Icons.padding_outlined,
  //               ),
  //               Text(counter.toString())
  //             ],
  //           ),
  //           label: Text('Template ${element.id!}'),
  //           selectedIcon: const Icon(Icons.padding_rounded),
  //         ),
  //       );
  //     }
  //     selectedTemplate = Provider.of<TemplateList>(context).selecetedTemplate;

  //     list.insert(
  //       0,
  //       const NavigationRailDestination(
  //         icon: Icon(
  //           Icons.save_outlined,
  //         ),
  //         label: Text('Selected \nTemplate'),
  //         selectedIcon: Icon(
  //           Icons.save_rounded,
  //         ),
  //       ),
  //     );
  //     // print('_selectedindex');
  //     // print(_selectedindex);
  //     // print(list.length);
  //     // print('allTemplates.length');
  //     // print(allTemplates.length);
  //     // print(_allTemplates.length);

  //     super.didChangeDependencies();
  //   }
  //   _init = true;
  // }
  _deleteTemplate() async {
    await Provider.of<TemplateList>(context, listen: false)
        .deleteTemplate(allTemplates[_selectedindex].id!, context)
        // ignore: avoid_print
        .then((value) async {
      await Provider.of<TemplateList>(context, listen: false)
          .fetchAllTemplateList(context: context);if (!mounted) return;   
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(APP_ROUTE_TEMPLATES);
      displaySnackbar(context, TITLE_TEMPLATE, 'Deleted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Templates'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(APP_ROUTE_ADD_EDIT_TEMPLATE_SCREEN)
                .then((value) {
              Navigator.of(context).pushReplacementNamed(APP_ROUTE_TEMPLATES);
              displaySnackbar(context, TITLE_TEMPLATE, value);
            });
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, constraint) {
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          elevation: 5,
                          // extended: true,
                          onDestinationSelected: (value) {
                            // if (_selectedindex == -1) {
                            //   return;
                            // }

                            // print('all allTemplates--->${allTemplates.length}');
                            // print('index--->$value');
                            setState(() {
                              _currentTemplate = false;
                              _selectedindex = value;
                              //  print(_selectedindex);
                            });
                          },
                          labelType: NavigationRailLabelType.selected,
                          selectedIndex: _selectedindex,
                          destinations: list,
                        ),
                      ),
                    ),
                  );
                }),
                const VerticalDivider(width: 0),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.all(5),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Template'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        allTemplates[_selectedindex].template!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.all(5),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Template Example'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(templateFormate(
                                        allTemplates[_selectedindex]
                                            .template!)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isLoading
          ? null
          : SizedBox(
              // width: MediaQuery.of(context).size.width * 0.29,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(APP_ROUTE_ADD_EDIT_TEMPLATE_SCREEN,
                                  arguments: allTemplates[_selectedindex]
                                      .id
                                      .toString())
                              .then((value) {
                            Navigator.of(context)
                                .pushReplacementNamed(APP_ROUTE_TEMPLATES);
                            displaySnackbar(context, TITLE_TEMPLATE, value);
                          });

                          //                    Navigator.of(context)
                          //     .pushNamed(APP_ROUTE_ADD_EDIT_APPOINTMENT)
                          //     .then((value) async {
                          //   final screenId = await getScreenValue();

                          //   if (screenId == '0' || screenId == '1') {
                          //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //         builder: (ctx) =>
                          //             TabScreen(screenId: int.parse(screenId))));
                          //   }
                          //   displaySnackbar(context, TITLE_APPOINTMENTS, value);
                          // });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Edit'),
                            Icon(Icons.edit_note_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_slectedTemplateId ==
                                    allTemplates[_selectedindex].id
                                ? 'Selected'
                                : 'Select'),
                            const Icon(Icons.save_rounded),
                          ],
                        ),
                        onPressed: () async {
                          _slectedTemplateId = allTemplates[_selectedindex].id;
                          await Provider.of<TemplateList>(context,
                                  listen: false)
                              .saveSelectedTemplate(
                                  allTemplates[_selectedindex].id!);

                          setState(() {});
                          // setState(() {
                          //   selectedTemplate = allTemplates[_selectedindex];
                          // });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: Text(
                                        'You sure want to delete Template ${allTemplates[_selectedindex].id}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await _deleteTemplate();
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Delete'),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
