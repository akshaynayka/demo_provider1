// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../provider/services.dart';
import '../provider/auth.dart';
import '../values/strings_en.dart';
import '../screens/tab_screen.dart';
import '../common_methods/common_methods.dart';

enum MoreOptions {
  Edit,
  Delete,
}

class ServiceListTile extends StatefulWidget {
  final String type;
  // final Animation animation;
  // final ValueNotifier<int> index;

  const ServiceListTile({
    ObjectKey? key,
    required this.type,
    // required this.animation,
    // required this.index
  }) : super(key: key);

  @override
  State<ServiceListTile> createState() => _ServiceListTileState();
}

class _ServiceListTileState extends State<ServiceListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController favAnimationControllar;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    favAnimationControllar = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
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
    final service = Provider.of<Service>(context);
    final services = Provider.of<Services>(context);
    final authData = Provider.of<Auth>(context);

    return ListTile(
      key: widget.key,
      leading: const Icon(Icons.miscellaneous_services, size: 40.0),
      title: Text(service.name),
      subtitle: Text(service.status),
      trailing: Consumer<Service>(
        builder: (ctx, _, child) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: service.favorite == 'yes'
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
                await services
                    .toggleFavoriteStatus(
                        widget.type, service.id, context, authData.token!)
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
                      await Provider.of<Services>(context, listen: false)
                          .deleteService(service.id!, widget.type, context);

                  if (response) {
                    if (!mounted) return;
                    displaySnackbar(context, TITLE_SERVICE, TITLE_DELETED);
                  }
                } else {
                  Navigator.of(context)
                      .pushNamed(APP_ROUTE_ADD_EDIT_SERVICE, arguments: {
                    'id': service.id,
                  }).then((value) {
                    if (value != null && value != '') {
                      displaySnackbar(context, TITLE_SERVICE, value);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const TabScreen(screenId: 4)));
                    }
                  });
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: MoreOptions.Edit,
                  child: Text(TITLE_EDIT),
                ),
                const PopupMenuItem(
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
      //     APP_ROUTE_SERVICE_DETAIL,
      //     arguments: {'id': service.id, 'type': widget.type},
      //   ).then((value) {
      //     if (value == true) {
      //       Navigator.of(context).pushReplacement(MaterialPageRoute(
      //           builder: (ctx) => const TabScreen(screenId: 4)));
      //     }
      //   });
      // },
    );
  }
}
