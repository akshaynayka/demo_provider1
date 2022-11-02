// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animations/animations.dart';
import 'package:demo_provider1/screens/appointments/appointment_details.dart';
import 'package:demo_provider1/values/app_colors.dart';

import '../../common_methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../values/strings_en.dart';
import '../../widgets/appointment_list_tile.dart';
import '../../provider/appointments.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  AppointmentsScreenState createState() => AppointmentsScreenState();
}

class AppointmentsScreenState extends State<AppointmentsScreen> {
  var _isInit = true;
  var _isLoading = false;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _todayScrollController = ScrollController();
  late int _page;
  var _lastpage;
  var _todayPage;
  var _todayLastPage;

  @override
  void dispose() {
    _scrollController.dispose();
    _todayScrollController.dispose();
    super.dispose();
  }

  getPages(int page) async {
    _page = page;
    final pageResponse = await Provider.of<Appointments>(context, listen: false)
        .fetchAllAppointment(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  getToadyPages(page) async {
    _todayPage = page;
    final pageResponse = await Provider.of<Appointments>(context, listen: false)
        .fetchTodayAppointment(page, context: context);
    _todayPage = pageResponse['currentPage'];
    _todayLastPage = pageResponse['lastPage'];
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
    _todayPage = 1;

    Provider.of<Appointments>(context, listen: false)
        .resetAppointmentWithPagination();
    getPages(_page);
    getToadyPages(_todayPage);

    _todayScrollController.addListener(() {
      if (_todayScrollController.position.pixels ==
              _todayScrollController.position.maxScrollExtent &&
          _todayPage <= _todayLastPage) {
        _todayPage++;
        getToadyPages(_todayPage);
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

    setScreenValue('1');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Appointments>(context).rebuildWidget(context: context);
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _refreshAppointment(BuildContext context, int type) async {
    if (type == 0) {
      await Provider.of<Appointments>(context, listen: false)
          .fetchTodayAppointment(1, context: context)
          .then((value) {});
    } else {
      await Provider.of<Appointments>(context, listen: false)
          .fetchAllAppointment(1, context: context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final appointmentData = Provider.of<Appointments>(context);
    final todayAppointments = appointmentData.todayAppointments;
    final appointments = appointmentData.allAppointments;
    // print(DateTime.parse(appointments[0].appointmentDate)
    //     .isBefore(DateTime.parse(appointments[1].appointmentDate)));
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : DefaultTabController(
            length: 2,
            child: DefaultTabController(
              length: 2,
              child: SizedBox(
                height: deviceSize.height,
                child: LayoutBuilder(
                  builder: ((context, constraints) => Column(
                        children: [
                          SizedBox(height: constraints.biggest.height * 0.01),
                          SizedBox(
                            height: constraints.biggest.height / 6.72,
                            child: AppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              bottom: TabBar(
                                // onTap: (value) async {
                                //   // print(constraints.biggest.height);
                                //   await _refreshAppointment(context, value);
                                // },
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
                          // SizedBox(
                          //   height: constraints.biggest.height * 0.01,
                          // ),
                          SizedBox(
                            height: constraints.biggest.height * 0.8325,
                            //     ? deviceSize.height * 0.6395
                            //     : deviceSize.height * 0.55,
                            child: TabBarView(
                              // physics: const NeverScrollableScrollPhysics(),
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                // first tab bar view widget
                                RefreshIndicator(
                                  onRefresh: () =>
                                      _refreshAppointment(context, 0),
                                  child: todayAppointments.isEmpty
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
                                      : ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          controller: _todayScrollController,
                                          padding: const EdgeInsets.all(8),
                                          itemCount: todayAppointments.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return OpenContainer(
                                              closedElevation: 0,
                                              closedBuilder: (BuildContext _,
                                                      VoidCallback action) =>
                                                  InkWell(
                                                splashColor: primaryColor,
                                                onTap: action,
                                                child: ChangeNotifierProvider
                                                    .value(
                                                  value:
                                                      todayAppointments[index],
                                                  child:
                                                      const AppointmentListTile(
                                                    type: 'today',
                                                  ),
                                                ),
                                              ),
                                              openBuilder: (BuildContext _,
                                                      VoidCallback __) =>
                                                  ChangeNotifierProvider.value(
                                                      value: todayAppointments[
                                                          index],
                                                      child:
                                                          const AppointmentDetails()),
                                            );
                                          }),
                                ),

                                // second tab bar viiew widget
                                RefreshIndicator(
                                  // key: _refreshAllAppointment,
                                  onRefresh: () =>
                                      _refreshAppointment(context, 1),
                                  child: appointments.isEmpty
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
                                      : ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          controller: _scrollController,
                                          padding: const EdgeInsets.all(8),
                                          itemCount: appointments.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              OpenContainer(
                                            closedElevation: 0,
                                            closedBuilder: (BuildContext _,
                                                    VoidCallback action) =>
                                                InkWell(
                                              splashColor: primaryColor,
                                              onTap: action,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value: appointments[index],
                                                child:
                                                    const AppointmentListTile(
                                                  type: 'all',
                                                ),
                                              ),
                                            ),
                                            openBuilder: (BuildContext _,
                                                    VoidCallback __) =>
                                                ChangeNotifierProvider.value(
                                              value: appointments[index],
                                              child: const AppointmentDetails(),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}
