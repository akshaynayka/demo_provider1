import '../../provider/customer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef CustomerCallback = void Function(Customer val);

class CustomerSearchDropdown extends StatefulWidget {
  final CustomerCallback callback;

  const CustomerSearchDropdown({Key? key, required this.callback})
      : super(key: key);
  @override
  CustomerSearchDropdownState createState() => CustomerSearchDropdownState();
}

class CustomerSearchDropdownState extends State<CustomerSearchDropdown> {
  final ScrollController _scrollController = ScrollController();

  late int _page;
  late int _lastpage;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getPages(page) async {
    _page = page;
    final pageResponse = await Provider.of<Customers>(context, listen: false)
        .fetchAllDropdownCustomers(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      // _isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      // _isLoading = true;
    });
    _page = 1;
    Provider.of<Customers>(context, listen: false).resetsearchCustomers();
    Provider.of<Customers>(context, listen: false).resetDropdownCustomers();
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
    final customerData = Provider.of<Customers>(context, listen: false);
    var customers = customerData.allDropdownCustomers;
    final searchCustomers = customerData.searchCustomersList;
    // print(searchCustomers.length);
    final height = MediaQuery.of(context).size.height * 0.01;
    // to be improve
    if (searchCustomers.isNotEmpty) {
      customers = searchCustomers;
    }

    return WillPopScope(
      onWillPop: () async {
        // print('calling reset search');

        return true;
      },
      child: Center(
        child: Container(
          height: height * 80,
          margin: EdgeInsets.only(top: height),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'Search ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                onChanged: (value) {
                  if (value.length > 2) {
                    Provider.of<Customers>(context, listen: false)
                        .searchCustomers(value, _page)
                        .then((value) {
                      setState(() {
                        customers = customerData.searchCustomersList;
                      });
                    });
                  } else {
                    Provider.of<Customers>(context, listen: false)
                        .resetsearchCustomers();
                    setState(() {
                      customers = customerData.allDropdownCustomers;
                    });
                  }
                },
              ),
              SizedBox(
                height: height * 70,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    trackVisibility: MaterialStateProperty.all(true),
                    thickness: MaterialStateProperty.all(8),
                  ),
                  child: Scrollbar(
                    radius: Radius.circular(height),
                    interactive: true,
                    controller: _scrollController,
                    thickness: 5,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      padding: EdgeInsets.all(height),
                      itemCount: customers.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(customers[index].fullName),
                        onTap: () {
                          widget.callback(customers[index]);

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
