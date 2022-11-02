import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../common_methods/common_methods.dart';
import '../values/strings_en.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/customers/customers_screen.dart';
import '../screens/services/services_screen.dart';
import '../widgets/side_drawer.dart';
import '../widgets/animated_floating_action_button.dart';


class TabScreen extends StatefulWidget {
  final int? screenId;

  const TabScreen({Key? key, this.screenId}) : super(key: key);

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  GlobalKey key = GlobalKey();
  bool _init = false;
  
  // ignore: prefer_final_fields
  bool _isLoading = false;
  List<Map<String, Object>> _pages = [];
  // FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void didChangeDependencies() async {
    if (!_init) {
      _pages = [
        {
          'page': const HomeScreen(),
          'title': dotenv.get('APP_TITLE'),
        },
        {
          'page': const AppointmentsScreen(),
          'title': TITLE_APPOINTMENTS,
        },
        {
          'page': const LoadingScreen(),
          'title': TITLE_ADD_APPOINTMENTS,
        },
        {
          'page': const CustomersScreen(),
          'title': TITLE_CUSTOMERS,
        },
        {
          'page': const ServicesScreen(),
          'title': TITLE_SERVICES,
        },
      ];

      _init = true;
    }
    super.didChangeDependencies();
  }

  int _selectedPageIndex = 0;

  @override
  void initState() {
    if (widget.screenId != null) {
      _selectedPageIndex = widget.screenId!;
    }

    // _messaging.getToken().then((token) {
    //   print(token);
    // });

    super.initState();
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
    // print('MediaQuery.of(context).padding.bottom');
    // print(MediaQuery.of(context).devicePixelRatio);
    // print(MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
          // 'Tab'
        ),
      ),
      drawer: const SideDrawer(),
      floatingActionButton: const AnimatedFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            key: key,
            unselectedItemColor: Theme.of(context).unselectedWidgetColor,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: selectPage,
            backgroundColor: Colors.blueGrey[50],
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                label: TITLE_HOME,
                icon: Icon(Icons.home),
              ),
              const BottomNavigationBarItem(
                label: TITLE_APPOINTMENTS,
                icon: Icon(Icons.alarm),
              ),
              BottomNavigationBarItem(
                  icon: Container(
                    height: kBottomNavigationBarHeight * 0.5,
                    //  width: MediaQuery.of(context).size.width / 10,

                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: IconButton(
                        alignment: Alignment.topCenter,
                        icon: const Icon(
                          Icons.add,
                          // color: Theme.of(context).primaryColor,
                          // size: kBottomNavigationBarHeight * .5
                          //  *
                          //     (constraints.biggest.width)

                          // ((height * width) * 0.7) *
                          //     MediaQuery.of(context).size.aspectRatio *
                          //     MediaQuery.of(context).devicePixelRatio *0.1,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(APP_ROUTE_ADD_EDIT_APPOINTMENT);
                        }),
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                label: TITLE_CUSTOMERS,
                // ignore: unnecessary_const
                icon: Icon(Icons.people),
              ),
              const BottomNavigationBarItem(
                label: TITLE_SERVICES,
                icon: Icon(Icons.miscellaneous_services),
              ),
            ],
          ),
          Positioned(
            left: width * 21,
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  height: kBottomNavigationBarHeight,
                  width: width * 8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height * width)),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(APP_ROUTE_ADD_EDIT_APPOINTMENT)
                        .then((value) async {
                      final screenId = await getScreenValue();

                      if (screenId == '0' || screenId == '1') {
                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) =>
                                TabScreen(screenId: int.parse(screenId!))));
                      }
                      if (!mounted) return;
                      displaySnackbar(context, TITLE_APPOINTMENTS, value);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: width * 0.5,
                        top: (kBottomNavigationBarHeight / 10) * 0.5),
                    height: kBottomNavigationBarHeight * 0.9,
                    width: width * 7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(
                          (kBottomNavigationBarHeight / 10) * width),
                      // border: Border.all(width: 0)
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: buttonTextColor,
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

// class Add extends StatefulWidget {
//   const Add({Key? key}) : super(key: key);

//   @override
//   State<Add> createState() => _AddState();
// }

// class _AddState extends State<Add> {
//   @override
//   void didChangeDependencies() {
//     Navigator.of(context).pushNamed(APP_ROUTE_ADD_EDIT_APPOINTMENT);
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Loading...'),
//     );
//   }
// }
