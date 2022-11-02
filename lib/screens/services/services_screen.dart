// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/services.dart';
import '../../common_methods/common_methods.dart';
import '../../screens/services/service_details.dart';
import '../../values/strings_en.dart';
import '../../widgets/servicelist_tile.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isRefreshing = false;

  GlobalKey<AnimatedListState> favServiceKey = GlobalKey();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0,
  );
  final ScrollController _favoriteScrollController = ScrollController();
  int _page = 0;
  int _lastpage = 0;
  int _favoritePage = 0;
  int _favoriteLastPage = 0;

  var serviceData;
  late List<Service> favServices;
  late List<Service> services;
  // ValueNotifier<int> tabVal = ValueNotifier(0);

  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // );
  // late final Animation<Offset> _offsetAnimation = Tween<Offset>(
  //   begin: Offset.zero,
  //   end: const Offset(1.5, 0.0),
  // ).animate(CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.linear,
  // ));

  @override
  void dispose() {
    _scrollController.dispose();
    _favoriteScrollController.dispose();
    super.dispose();
  }

  Future<void> getPages(int page) async {
    _page = page;
    final pageResponse = await Provider.of<Services>(context, listen: false)
        .fetchAllService(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getFavoritePages(int page) async {
    _favoritePage = page;

    final pageResponse = await Provider.of<Services>(context, listen: false)
        .fetchFavoriteService(page, context: context);
    _favoritePage = pageResponse['currentPage'];
    _favoriteLastPage = pageResponse['lastPage'];
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  void initState() {
    // final time = DateTime.now();
    setState(() {
      _isLoading = true;
    });
    // _page = 1;
    // _favoritePage = 1;
    // Provider.of<Services>(context, listen: false).resetServicesWithPagination();
    // getFavoritePages(_favoritePage);
    // getPages(_page);

    // _favoriteScrollController.addListener(() {
    //   if (_favoriteScrollController.position.pixels ==
    //           _favoriteScrollController.position.maxScrollExtent &&
    //       _favoritePage <= _favoriteLastPage) {
    //     _favoritePage++;

    //     getFavoritePages(_favoritePage);
    //   }
    // });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //           _scrollController.position.maxScrollExtent &&
    //       _page <= _lastpage) {
    //     _page++;

    //     getPages(_page);
    //   }
    // });

    setScreenValue('4');

    // setState(() {
    //   log('res : ${DateTime.now().difference(time)}');
    //   _isLoading = false;
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final time = DateTime.now();
      setState(() {
        _isLoading = true;
      });
      _page = 1;
      _favoritePage = 1;
      Provider.of<Services>(context, listen: false)
          .resetServicesWithPagination();
      await getFavoritePages(_favoritePage);
      await getPages(_page);

      _favoriteScrollController.addListener(() {
        if (_favoriteScrollController.position.pixels ==
                _favoriteScrollController.position.maxScrollExtent &&
            _favoritePage <= _favoriteLastPage) {
          _favoritePage++;
          if (!_isInit) {
            getFavoritePages(_favoritePage);
          }
        }
      });

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            _page <= _lastpage) {
          _page++;
          if (!_isInit) {
            getPages(_page);
          }
        }
      });

      setScreenValue('4');

      setState(() {
        log('res : ${DateTime.now().difference(time)}');
        _isLoading = false;
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  Future<void> _refreshServices(BuildContext context, int type) async {
    setState(() {
      _isRefreshing = true;
    });
    if (type == 0) {
      await Provider.of<Services>(context, listen: false)
          .fetchFavoriteService(1, context: context);
    } else {
      await Provider.of<Services>(context, listen: false)
          .fetchAllService(1, context: context);
    }
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    serviceData = Provider.of<Services>(context);
    favServices = serviceData.favoriteServices;
    services = serviceData.services;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : DefaultTabController(
            // initialIndex: tabVal.value,
            length: 2,
            child: Column(
              children: [
                SizedBox(height: deviceSize.height * 0.01918),
                SizedBox(
                  height: 75,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).backgroundColor,
                    bottom: TabBar(
                      onTap: (value) {
                        // setState(() {
                        //   _refreshServices(context, value);
                        // });
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
                            TITLE_FAVORITE,
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
                  height: deviceSize.height * 0.6379,
                  // ? deviceSize.height * 0.6395
                  // : deviceSize.height * 0.55,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // first tab bar view widget

                      RefreshIndicator(
                        onRefresh: () => _refreshServices(context, 0),
                        child: _isRefreshing
                            ? const Center(child: CircularProgressIndicator())
                            : favServices.isEmpty
                                ? LayoutBuilder(
                                    builder: (context, constraints) => ListView(
                                      // shrinkWrap: true,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minHeight: constraints.maxHeight),
                                          child: const Center(
                                              child: Text(
                                                  TITLE_NO_DATA_AVAILABLE)),
                                        ),
                                      ],
                                    ),
                                  )
                                :
                                // ListView.builder(
                                // key: favServiceKey,
                                // itemCount: favServices.length,
                                // itemBuilder: (
                                //   BuildContext context,
                                //   int index,
                                // ) {
                                //   return ChangeNotifierProvider.value(
                                //     value: favServices[index],
                                //     child: ServiceListTile(
                                //       type: 'favorite',
                                //       // animation: animation,
                                //       index: index,
                                //     ),
                                //   );
                                // }
                                ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    controller: _favoriteScrollController,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: favServices.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            OpenContainer(
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      transitionType:
                                          ContainerTransitionType.fadeThrough,
                                      closedBuilder: (_, VoidCallback action) =>
                                          GestureDetector(
                                        onTap: action,
                                        child: ChangeNotifierProvider.value(
                                          value: favServices[index],
                                          child: ServiceListTile(
                                            type: 'favorite',
                                            // index: tabVal,
                                            key: ObjectKey(favServices[index]),
                                          ),
                                        ),
                                      ),
                                      openBuilder: (_, VoidCallback __) =>
                                          ChangeNotifierProvider.value(
                                        value: favServices[index],
                                        child: const ServiceDetails(),
                                      ),
                                      // onClosed: (_) =>
                                      // Navigator.of(context).pop(),
                                    ),
                                  ),
                      ),
                      // ),
                      // second tab bar viiew widget
                      RefreshIndicator(
                        onRefresh: () => _refreshServices(context, 1),
                        child: _isRefreshing
                            ? const Center(child: CircularProgressIndicator())
                            : services.isEmpty
                                ? LayoutBuilder(
                                    builder: (context, constraints) => ListView(
                                      // shrinkWrap: true,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minHeight: constraints.maxHeight),
                                          child: const Center(
                                              child: Text(
                                                  TITLE_NO_DATA_AVAILABLE)),
                                        ),
                                      ],
                                    ),
                                  )
                                : Scrollbar(
                                    controller: _scrollController,
                                    interactive: true,
                                    radius: const Radius.circular(5),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      scrollDirection: Axis.vertical,
                                      itemCount: services.length,
                                      itemBuilder: (context, index) =>
                                          OpenContainer(
                                        transitionDuration:
                                          const  Duration(milliseconds: 400),
                                        closedBuilder:
                                            (_, VoidCallback action) =>
                                                ChangeNotifierProvider.value(
                                          value: services[index],
                                          child: const ServiceListTile(
                                            type: 'all',
                                            // index: tabVal,
                                            // key: ObjectKey(services[index]),
                                          ),
                                        ),
                                        openBuilder: (_, VoidCallback __) =>
                                            ChangeNotifierProvider.value(
                                          value: services[index],
                                          child: const ServiceDetails(),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
