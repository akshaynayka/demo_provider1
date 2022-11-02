// ignore_for_file: prefer_typing_uninitialized_variables

import '../../provider/services.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ServiceCallback = void Function(dynamic val);

class ServiceSearchDropdown extends StatefulWidget {
  final ServiceCallback callback;
  final serviceList;
  const ServiceSearchDropdown({
    Key? key,
    required this.callback,
    this.serviceList,
  }) : super(key: key);
  @override
  ServiceSearchDropdownState createState() => ServiceSearchDropdownState();
}

class ServiceSearchDropdownState extends State<ServiceSearchDropdown> {
  final ScrollController _scrollController = ScrollController();

  var _page;
  var _lastpage;
  List<dynamic> _serviceList = [];
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  getPages(page) async {
    _page = page;
    final pageResponse = await Provider.of<Services>(context, listen: false)
        .fetchAllDropdownService(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      //   // _isLoading = false;
    });
  }

  @override
  void initState() {
    // setState(() {
    // _isLoading = true;
    // });

    _page = 1;
    Provider.of<Services>(context, listen: false).resetsearchServices();

    Provider.of<Services>(context, listen: false).resetDropdownServices();
    getPages(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _page <= _lastpage) {
        _page++;
        getPages(_page);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.serviceList != null) {
      _serviceList = widget.serviceList;
    }
    final customerData = Provider.of<Services>(context, listen: false);
    var services = customerData.dropdownServices;
    final searchServices = customerData.searchServicesList;
    // to be improve
    if (searchServices.isNotEmpty) {
      services = searchServices;
    }
    final h = MediaQuery.of(context).size.height * 0.01;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<Services>(context, listen: false).resetsearchServices();
        widget.callback(_serviceList);
        return true;
      },
      child: SizedBox(
        height: h * 80,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.design_services_rounded),
                suffixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Search ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                if (value.length > 2) {
                  Provider.of<Services>(context, listen: false)
                      .searchServices(value, 1)
                      .then((value) {
                    setState(() {
                      services = customerData.searchServicesList;
                    });
                  });
                } else {
                  Provider.of<Services>(context, listen: false)
                      .resetsearchServices();
                  setState(() {
                    services = customerData.services;
                  });
                }
              },
            ),
            SizedBox(
              height: h * 63,
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thickness: MaterialStateProperty.all(20),
                ),
                child: Scrollbar(
                  interactive: true,
                  controller: _scrollController,
                  thickness: 5,
                  radius: Radius.circular(h),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CheckboxListTile(
                      title: Text(services[index].name),
                      value: _serviceList.firstWhere(
                                  (data) =>
                                      data['id'] ==
                                      int.parse(services[index].id!),
                                  orElse: () => null) !=
                              null
                          ? true
                          : false,
                      onChanged: (bool? value) {
                        if (value!) {
                          setState(() {
                            _serviceList.add({
                              'id': int.parse(services[index].id!),
                              'name': services[index].name,
                            });
                          });
                        } else {
                          setState(() {
                            _serviceList.removeWhere((data) =>
                                data['id'] == int.parse(services[index].id!));
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text(TITLE_ADD),
              onPressed: () async {
                Provider.of<Services>(context, listen: false)
                    .resetsearchServices();
                widget.callback(_serviceList);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
