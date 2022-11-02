import '../common_methods/common_methods.dart';
import '../values/app_routes.dart';
import '../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ShopFloatingActionWidget extends StatelessWidget {
  const ShopFloatingActionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0.1,
      spaceBetweenChildren: 5.0,
      spacing: 5.0,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.branding_watermark_outlined),
            label: TITLE_ADD_BRAND,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context)
                  .pushNamed(APP_ROUTE_ADD_EDIT_BRAND)
                  .then((value) {
                displaySnackbar(context, TITLE_BRAND, value);
              });
            }),
        SpeedDialChild(
          child: const Icon(Icons.category),
          label: TITLE_ADD_CATEGORY,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            Navigator.of(context)
                .pushNamed(APP_ROUTE_ADD_EDIT_CATEGORY)
                .then((value) {
              displaySnackbar(context, TITLE_CATEGORY, value);
            });
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.stroller_sharp),
            label: TITLE_ADD_PRODUCT,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context)
                  .pushNamed(APP_ROUTE_ADD_EDIT_PRODUCT)
                  .then((value) {
                displaySnackbar(context, TITLE_PRODUCT, value);
              });
            }),
      ],
    );
  }
}
