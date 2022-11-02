// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animations/animations.dart';
import 'package:demo_provider1/screens/appointments/appointment_details.dart';

import '../provider/templates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_methods/common_methods.dart';
import '../values/app_colors.dart';
import '../values/strings_en.dart';
import '../provider/status.dart';
import '../provider/appointments.dart';
import '../widgets/tile_widget.dart';
import '../widgets/appointment_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // var _isInit = true;
  var _isLoading = false;

  final ScrollController _recentScrollController = ScrollController();
  var _recentPage;
  var _recentLastPage;

  var _api1 = false;
  var _api2 = false;
  var _api3 = false;
  var _api4 = false;
  var _api5 = false;

  _dataLoaded(api1, api2, api3, api4, api5) {
    if (api1 && api2 && api3 && api4 && api5) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _recentScrollController.dispose();
    super.dispose();
  }

  Future<void> getRecentPages(int page) async {
    _recentPage = page;
    await Provider.of<Appointments>(context, listen: false)
        .fetchRecentAppointment(page, context: context)
        .then((value) {
      _recentPage = value['currentPage'];
      _recentLastPage = value['lastPage'];
      _api1 = true;
      // setState(() {
      //   _isLoading = false;
      // });
      _dataLoaded(_api1, _api2, _api3, _api4, _api5);
    });
  }

  @override
  void initState() {
    // setState(() {
    //   _isLoading = true;
    // });

    // _recentPage = 1;

    // Provider.of<Appointments>(context, listen: false)
    //     .resetAppointmentWithPagination();

    // getRecentPages(_recentPage);

    _getData();

    _recentScrollController.addListener(() {
      if (_recentScrollController.position.pixels ==
              _recentScrollController.position.maxScrollExtent &&
          _recentPage <= _recentLastPage) {
        _recentPage++;
        getRecentPages(_recentPage);
      }
    });

    setScreenValue('0');
    // checkUpdateAppVersion(context: context);
    super.initState();
  }

  _getData() async {
    _api1 = false;
    _api2 = false;
    _api3 = false;
    _api4 = false;
    _api5 = false;
    setState(() {
      _isLoading = true;
    });

    _recentPage = 1;

    await Provider.of<Appointments>(context, listen: false)
        .resetAppointmentWithPagination();
    getRecentPages(_recentPage);
    {
      if (!mounted) return;

      await Provider.of<Appointments>(context, listen: false)
          .fetchTodayCount(context: context)
          .then((value) {
        _api2 = true;
        _dataLoaded(_api1, _api2, _api3, _api4, _api5);
      });
      {
        if (!mounted) return;

        await Provider.of<Appointments>(context, listen: false)
            .fetchAllCount(context: context)
            .then((value) {
          _api3 = true;
          _dataLoaded(_api1, _api2, _api3, _api4, _api5);
        });
        {
          if (!mounted) return;
          await Provider.of<StatusList>(context, listen: false)
              .fetchAllStatus(context: context)
              .then((value) {
            _api4 = true;
            _dataLoaded(_api1, _api2, _api3, _api4, _api5);
          });
          {
            if (!mounted) return;

            await Provider.of<TemplateList>(context, listen: false)
                .fetchAllTemplateList(context: context)
                .then((value) {
              _api5 = true;
              _dataLoaded(_api1, _api2, _api3, _api4, _api5);
            });
          }
        }
      }
    }
  }

  Widget rowContainer(Widget widget1, Widget widget2, double width) {
    return Container(
      alignment: Alignment.center,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: width * 0.051),
            child: widget1,
          ),
          Container(
            padding: EdgeInsets.only(left: width * 0.051),
            child: widget2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final height = deviceSize.height * 0.01;
    //final w = deviceSize.width * 0.02;
    final appointmentData = Provider.of<Appointments>(context);
    final recentAppointments = appointmentData.recentAppointments;
    // log(recentAppointments.length.toString());
    final todayTotalCounts =
        Provider.of<Appointments>(context, listen: false).todayCounts;
    final allCounts =
        Provider.of<Appointments>(context, listen: false).allCounts;

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DefaultTabController(
              length: 2,
              child: SizedBox(
                height: deviceSize.height,
                child: Column(
                  children: [
                    SizedBox(height: deviceSize.height * 0.01918),
                    SizedBox(
                      height: height * 12,
                      child: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).backgroundColor,
                        bottom: TabBar(
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor:
                              Theme.of(context).unselectedWidgetColor,
                          tabs: const [
                            Tab(
                              icon: Icon(
                                Icons.today,
                              ),
                              child: Text(
                                TITLE_TODAY,
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
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: deviceSize.height * 0.255,
                        child: TabBarView(
                          children: [
                            // first tab bar view widget
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                rowContainer(
                                    TileWidget(
                                        TITLE_APPOINTMENTS,
                                        int.parse(
                                          todayTotalCounts['totalAppointments'],
                                        ).toInt()),
                                    TileWidget(
                                        TITLE_CUSTOMERS,
                                        int.parse(
                                          todayTotalCounts['totalCustomers'],
                                        ).toInt()),
                                    deviceSize.width),
                              ],
                            ),

                            // second tab bar view widget
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                rowContainer(
                                    TileWidget(
                                        TITLE_APPOINTMENTS,
                                        int.parse(
                                                allCounts['totalAppointments'])
                                            .toInt()),
                                    TileWidget(
                                        TITLE_CUSTOMERS,
                                        int.parse(allCounts['totalCustomers'])
                                            .toInt()),
                                    deviceSize.width),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: deviceSize.height * 0.0511,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: const Border(
                          bottom: BorderSide(
                              width: 1.0, color: borderColorLightBlack),
                        ),
                        color: Theme.of(context).shadowColor,
                      ),
                      child: Center(
                          child: Text(TITLE_RECENT_APPOINTMENTS,
                              style: TextStyle(
                                  fontSize: deviceSize.height * 0.0255))),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          return getRecentPages(1);
                        },
                        child: recentAppointments.isEmpty
                            ? LayoutBuilder(
                                builder: (context, constraints) => ListView(
                                  // shrinkWrap: true,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight),
                                      child: const Center(
                                          child: Text(TITLE_NO_DATA_AVAILABLE)),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: _recentScrollController,
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                shrinkWrap: true,
                                itemCount: recentAppointments.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        OpenContainer(
                                  closedBuilder:
                                      (BuildContext _, VoidCallback action) =>
                                          ChangeNotifierProvider.value(
                                    value: recentAppointments[index],
                                    child: const AppointmentListTile(
                                      type: 'recent',
                                    ),
                                  ),
                                  openBuilder: (BuildContext _,
                                          VoidCallback __) =>
                                      ChangeNotifierProvider.value(
                                          value: recentAppointments[index],
                                          child: const AppointmentDetails()),
                                ),
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
