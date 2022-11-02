// ignore_for_file: unused_local_variable

import '../../provider/auth.dart';
import 'package:provider/provider.dart';

import '../../values/app_routes.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import '../../values/api_end_points.dart';

import '../../http_request/http_request.dart' as http;

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  Widget sizebox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).token;

    Future<void> getUserData() async {
      final userData = await http.HttpRequest().getRequest(API_PROFILE, auth!);
    }

    getUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_MY_ACCOUNT),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Column(
              children: [
                sizebox(height: 25),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).backgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10)),
                      ],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://t3.ftcdn.net/jpg/03/46/83/96/240_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                          ))),
                ),
                sizebox(height: 20),
                Text(
                  'Jay Patel',
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor, fontSize: 25),
                ),
                sizebox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizebox(width: 30),
                    Text(
                      '9725106424',
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 15),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.verified_user, color: Colors.red),
                      label: const Text(
                        'Verify',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).backgroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(APP_ROUTE_EDIT_PROFILE);
                      },
                    ),
                    Text(
                      'js.jay.patel01@gmail.com',
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 15),
                    ),
                    TextButton.icon(
                      icon:
                          const Icon(Icons.verified_user, color: Colors.green),
                      label: const Text(
                        'Verified',
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.house_outlined),
                title: const Text(TITLE_MY_ADDRESS),
                subtitle: const Text('Default Address here'),
                trailing: TextButton(
                  child: Text(
                    TITLE_MANAGE_ADDRESS,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(APP_ROUTE_MANAGE_ADDRESS);
                  },
                ),
              )),
          Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text(TITLE_CHANGE_PASSWORD),
                subtitle: const Text('****'),
                trailing: TextButton(
                  child: Text(
                    TITLE_CHANGE,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(APP_ROUTE_CHANGE_PASSWORD);
                  },
                ),
              )),
        ],
      ),
    );
  }
}
