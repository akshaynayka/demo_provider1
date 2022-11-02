import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../provider/auth.dart';

import '../values/strings_en.dart';
import '../values/app_routes.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  Widget rowTileContainer(IconData icon, String title, Function()? route) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 8),
      height: 40,
      child: InkWell(
        onTap: route,
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(width: 32),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            AppBar(
              title: Text(dotenv.get('APP_TITLE')),
              automaticallyImplyLeading: false,
            ),
            rowTileContainer(
              Icons.home,
              TITLE_HOME,
              () {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
            rowTileContainer(
              Icons.person,
              TITLE_MY_ACCOUNT,
              () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(APP_ROUTE_MY_ACCOUNT);
              },
            ),
            // rowTileContainer(
            //   Icons.person_pin_rounded,
            //   TITLE_IMPORT_CONTACTS,
            //   () {
            //     Navigator.pop(context);
            //     Navigator.of(context).pushNamed(APP_ROUTE_CONTACT);
            //   },
            // ),
            rowTileContainer(
              Icons.library_books_rounded,
              TITLE_MESSAGE_TEMPLATES,
              () => Navigator.of(context).pushNamed(APP_ROUTE_TEMPLATES),
            ),
            rowTileContainer(
              Icons.exit_to_app,
              TITLE_LOGOUT,
              () {
                Navigator.pop(context);

                Provider.of<Auth>(context, listen: false).logout();

                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(TITLE_VIRSION),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      TITLE_POWERED_BY,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
