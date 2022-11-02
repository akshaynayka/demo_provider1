import '../values/app_colors.dart';

import '../../common_methods/common_methods.dart';
import '../../screens/tab_screen.dart';
import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AnimatedFloatingActionButton extends StatelessWidget {
  const AnimatedFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      foregroundColor: buttonTextColor,
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0.1,
      spaceBetweenChildren: 5.0,
      spacing: 5.0,
      backgroundColor: Theme.of(context).primaryColor,
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.perm_contact_calendar_outlined,
            color: buttonTextColor,
          ),
          label: TITLE_ADD_APPOINTMENTS,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            final fun = ((value) {
              displaySnackbar(context, TITLE_APPOINTMENTS, value);
            });

            final navigator = Navigator.of(context);
            Navigator.of(context)
                .pushNamed(APP_ROUTE_ADD_EDIT_APPOINTMENT)
                .then((value) async {
              final screenId = await getScreenValue();
              if (screenId == '0' || screenId == '1') {
                navigator.pushReplacement(MaterialPageRoute(
                    builder: (ctx) =>
                        TabScreen(screenId: int.parse(screenId!))));
              }
              fun(value);
              // displaySnackbar(context, TITLE_APPOINTMENTS, value);
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.people,
            color: buttonTextColor,
          ),
          label: TITLE_ADD_CUSTOMER,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            final navigator = Navigator.of(context);
            final buildContext = context;
            Navigator.of(context)
                .pushNamed(APP_ROUTE_ADD_EDIT_CUSTOMER)
                .then((value) async {
              final screenId = await getScreenValue();

              if (screenId == '3') {
                navigator.pushReplacement(MaterialPageRoute(
                    builder: (ctx) =>
                        TabScreen(screenId: int.parse(screenId!))));
              }

              displaySnackbar(buildContext, TITLE_CUSTOMER, value);
            });
          },
        ),
        SpeedDialChild(
            child: const Icon(
              Icons.miscellaneous_services,
              color: buttonTextColor,
            ),
            label: TITLE_ADD_SERVICE,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context)
                  .pushNamed(APP_ROUTE_ADD_EDIT_SERVICE)
                  .then((value) async {
               
                final screenId = await getScreenValue();
             
                if (screenId == '4') {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          TabScreen(screenId: int.parse(screenId!))));
                }

                displaySnackbar(context, TITLE_SERVICES, value);
              });
            }),
      ],
    );
  }
}
