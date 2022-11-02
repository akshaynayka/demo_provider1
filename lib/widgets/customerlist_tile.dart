// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../values/app_routes.dart';
import '../values/app_colors.dart';
import '../provider/customer.dart';
import '../provider/auth.dart';
import '../values/strings_en.dart';
import '../common_methods/common_methods.dart';

enum MoreOptions {
  Edit,
  Address,
  Delete,
}

class CustomerListTile extends StatefulWidget {
  final String type;

  const CustomerListTile({Key? key, required this.type}) : super(key: key);

  @override
  State<CustomerListTile> createState() => _CustomerListTileState();
}

class _CustomerListTileState extends State<CustomerListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController favAnimationControllar;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    favAnimationControllar =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    animation = ColorTween(begin: favoritColor, end: Colors.white)
        .animate(favAnimationControllar)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    favAnimationControllar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<Customer>(context);
    final customerfav = Provider.of<Customers>(context);
    final authData = Provider.of<Auth>(context);

    return ListTile(
      leading: const Icon(Icons.person, size: 40.0),
      title: Text(customer.fullName),
      subtitle: Text(customer.mobileNo),
      trailing: Consumer<Customer>(
        builder: (ctx, _, child) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: customer.favorite == 'yes'
                  ? Icon(
                      Icons.favorite,
                      color: animation.value,
                    )
                  : const Icon(
                      Icons.favorite_border_outlined,
                      color: favoritColor,
                    ),
              onPressed: () async {
                favAnimationControllar.repeat();
                await customerfav
                    .toggleFavoriteStatus(
                        widget.type, customer.id, context, authData.token)
                    .then((value) {
                  if (value) {
                    favAnimationControllar.animateBack(0);
                  }
                });
              },
            ),
            PopupMenuButton(
              onSelected: (MoreOptions selectedValue) async {
                if (selectedValue == MoreOptions.Delete) {
                  final response =
                      await Provider.of<Customers>(context, listen: false)
                          .deleteCustomer(customer.id!, widget.type, context);
                  if (response) {
                    if (!mounted) return;
                    displaySnackbar(context, TITLE_CUSTOMER, TITLE_DELETED);
                  }
                } else if (selectedValue == MoreOptions.Edit) {
                  Navigator.of(context).pushNamed(APP_ROUTE_ADD_EDIT_CUSTOMER,
                      arguments: {'id': customer.id, 'type': widget.type});
                } else {
                  Navigator.of(context)
                      .pushNamed(APP_ROUTE_MANAGE_CUSTOMER_ADDRESS, arguments: {
                    'id': customer.id,
                    'type': widget.type
                  }).then((value) {
                    if (value != null && value != '') {
                      displaySnackbar(context, TITLE_CUSTOMER, value);
                    }
                  });
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: MoreOptions.Edit,
                  child: Text(TITLE_EDIT),
                ),
                PopupMenuItem(
                  value: MoreOptions.Address,
                  child: Text(TITLE_ADDRESS),
                ),
                PopupMenuItem(
                  value: MoreOptions.Delete,
                  child: Text(TITLE_DELETE),
                ),
              ],
            ),
          ],
        ),
      ),
      // onTap: () {
      //   Navigator.of(context).pushNamed(
      //     APP_ROUTE_CUSTOMER_DETAIL,
      //     arguments: {'id': customer.id, 'type': widget.type},
      //   ).then((value) {
      //     if (value = true) {
      //       Navigator.of(context).pushReplacement(MaterialPageRoute(
      //           builder: (ctx) => const TabScreen(screenId: 3)));
      //     }
      //   });
      // },
    );
  }
}
