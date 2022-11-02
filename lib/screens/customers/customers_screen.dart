// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animations/animations.dart';
import 'package:demo_provider1/screens/customers/customer_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_methods/common_methods.dart';
import '../../provider/customer.dart';
import '../../values/strings_en.dart';
import '../../widgets/customerlist_tile.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  CustomersScreenState createState() => CustomersScreenState();
}

class CustomersScreenState extends State<CustomersScreen> {
  var _isInit = true;
  var _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _favoriteScrollController = ScrollController();
  var _page;
  var _lastpage;
  var _favoritePage;
  var _favoriteLastPage;

  @override
  void dispose() {
    _scrollController.dispose();
    _favoriteScrollController.dispose();
    super.dispose();
  }

  Future<void> getPages(int page) async {
    _page = page;
    final pageResponse = await Provider.of<Customers>(context, listen: false)
        .fetchAllCustomers(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getFavoritePages(int page) async {
    _favoritePage = page;
    final pageResponse = await Provider.of<Customers>(context, listen: false)
        .fetchFavoriteCustomers(page, context: context);
    _favoritePage = pageResponse['currentPage'];
    _favoriteLastPage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _page = 1;
    _favoritePage = 1;

    Provider.of<Customers>(context, listen: false)
        .resetCustomersWithPagination();
    getPages(_page);
    getFavoritePages(_favoritePage);

    _favoriteScrollController.addListener(() {
      if (_favoriteScrollController.position.pixels ==
              _favoriteScrollController.position.maxScrollExtent &&
          _favoritePage <= _favoriteLastPage) {
        _favoritePage++;
        getFavoritePages(_favoritePage);
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _page <= _lastpage) {
        _page++;
        getPages(_page);
      }
    });

    setScreenValue('3');

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Customers>(context).rebuildWidget(context: context);
    }
    _isInit = false;
    setState(() {});

    super.didChangeDependencies();
  }

  var _loadData = false;
  Future<void> _refreshCustomers(BuildContext context, int type) async {
    setState(() {
      _loadData = true;
    });
    if (type == 0) {
      await Provider.of<Customers>(context, listen: false)
          .fetchFavoriteCustomers(1, context: context);
    } else {
      await Provider.of<Customers>(context, listen: false)
          .fetchAllCustomers(1, context: context);
    }
    setState(() {
      _loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final customerData = Provider.of<Customers>(context);
    final favcustomers = customerData.favoriteCustomers;
    final customers = customerData.allCustomers;
    return DefaultTabController(
      length: 2,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  SizedBox(height: deviceSize.height * 0.01918),
                  SizedBox(
                    height: 74,
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Theme.of(context).backgroundColor,
                      bottom: TabBar(
                        onTap: (value) async {
                          // await _refreshCustomers(context, value);
                        },
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor:
                            Theme.of(context).unselectedWidgetColor,
                        tabs: const [
                          Tab(
                            icon: Icon(
                              Icons.favorite,
                            ),
                            child: Text(
                              TITLE_FAVORITES,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.list,
                            ),
                            child: Text(
                              TITLE_ALL,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.01279,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.6399,
                    // ? deviceSize.height * 0.6395
                    // : deviceSize.height * 0.55,
                    child: TabBarView(
                      //   physics: NeverScrollableScrollPhysics(),
                      children: [
                        // first tab bar view widget
                        _loadData
                            ? const Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: () => _refreshCustomers(context, 0),
                                child: favcustomers.isEmpty
                                    ? LayoutBuilder(
                                        builder: (context, constraints) =>
                                            ListView(
                                          // shrinkWrap: true,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  minHeight:
                                                      constraints.maxHeight),
                                              child: const Center(
                                                  child: Text(
                                                      TITLE_NO_DATA_AVAILABLE)),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Scrollbar(
                                        radius: const Radius.circular(15),
                                        child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          controller: _favoriteScrollController,
                                          padding: const EdgeInsets.all(8),
                                          itemCount: favcustomers.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              OpenContainer(
                                            transitionDuration: const Duration(
                                                milliseconds: 400),
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            closedBuilder:
                                                (BuildContext context,
                                                        VoidCallback action) =>
                                                    GestureDetector(
                                              onTap: action,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value: favcustomers[index],
                                                child: CustomerListTile(
                                                  type: 'favorite',
                                                  key: ObjectKey(
                                                      favcustomers[index]),
                                                ),
                                              ),
                                            ),
                                            openBuilder: (_, VoidCallback __) =>
                                                ChangeNotifierProvider.value(
                                                    value: favcustomers[index],
                                                    child:
                                                        const CustomerDetails()),
                                          ),
                                        ),
                                      ),
                              ),
                        // second tab bar viiew widget
                        RefreshIndicator(
                          onRefresh: () => _refreshCustomers(context, 1),
                          child: customers.isEmpty
                              ? LayoutBuilder(
                                  builder: (context, constraints) => ListView(
                                    // shrinkWrap: true,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight),
                                        child: const Center(
                                            child:
                                                Text(TITLE_NO_DATA_AVAILABLE)),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: customers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          OpenContainer(
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    closedBuilder: (BuildContext context,
                                            VoidCallback action) =>
                                        GestureDetector(
                                      onTap: action,
                                      child: ChangeNotifierProvider.value(
                                        value: customers[index],
                                        child:
                                            const CustomerListTile(type: 'all'),
                                      ),
                                    ),
                                    openBuilder: (_, VoidCallback __) =>
                                        ChangeNotifierProvider.value(
                                            value: customers[index],
                                            child: const CustomerDetails()),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
