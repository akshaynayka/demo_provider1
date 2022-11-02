// ignore_for_file: constant_identifier_names

import '../provider/shop.dart';
import '../screens/shop/shop_tab_screen.dart';
import '../common_methods/common_methods.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../values/app_routes.dart';

import '../values/strings_en.dart';

enum MoreOptions {
  Edit,
  Delete,
}

class BrandListTile extends StatelessWidget {
  final String type;

  const BrandListTile({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brandData = Provider.of<Brand>(context, listen: false);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.branding_watermark_outlined, size: 40.0),
        title: Text(brandData.name),
        subtitle: Text(brandData.status),
        trailing: Consumer<Brand>(
          builder: (ctx, _, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton(
                onSelected: (MoreOptions selectedValue) async {
                  if (selectedValue == MoreOptions.Delete) {
                    final response =
                        await Provider.of<Shop>(context, listen: false)
                            .deleteBrand(brandData.id!, context);
                    if (response) {
                      displaySnackbar(context, TITLE_BRAND, TITLE_DELETED);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const ShopTabScreen(screenId: 1)));
                    }
                  } else {
                    Navigator.of(context)
                        .pushNamed(APP_ROUTE_ADD_EDIT_BRAND, arguments: {
                      'id': brandData.id,
                    }).then((value) {
                      if (value != null && value != '') {
                        displaySnackbar(context, TITLE_BRAND, value);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => const ShopTabScreen(screenId: 1)));
                      }
                    });
                  }
                },
                itemBuilder: (_) => const[
                  PopupMenuItem(
                    value: MoreOptions.Edit,
                    child: Text(TITLE_EDIT),
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
        onTap: () {
          Navigator.of(context).pushNamed(
            APP_ROUTE_BRAND_DETAIL,
            arguments: {'id': brandData.id, 'type': type},
          ).then((value) {
            if (value == true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const ShopTabScreen(screenId: 1)));
            }
          });
        },
      ),
    );
  }
}
