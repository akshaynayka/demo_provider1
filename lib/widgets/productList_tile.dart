// ignore_for_file: constant_identifier_names, file_names, use_build_context_synchronously

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

class ProductListTile extends StatelessWidget {
  final String type;

  const ProductListTile({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.shop_two, size: 40.0),
        title: Text(productData.name),
        subtitle: Text(productData.status),
        trailing: Consumer<Product>(
          builder: (ctx, _, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton(
                onSelected: (MoreOptions selectedValue) async {
                  if (selectedValue == MoreOptions.Delete) {
                    final response =
                        await Provider.of<Shop>(context, listen: false)
                            .deleteProduct(productData.id!, context);
                    if (response) {
                      
                      displaySnackbar(context, TITLE_PRODUCT, TITLE_DELETED);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const ShopTabScreen(screenId: 3)));
                    }
                  } else {
                    Navigator.of(context)
                        .pushNamed(APP_ROUTE_ADD_EDIT_PRODUCT, arguments: {
                      'id': productData.id,
                    }).then((value) {
                      if (value != null && value != '') {
                        displaySnackbar(context, TITLE_PRODUCT, value);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => const ShopTabScreen(screenId: 3)));
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
        onTap: () {
          Navigator.of(context).pushNamed(
            APP_ROUTE_PRODUCT_DETAIL,
            arguments: {'id': productData.id, 'type': type},
          ).then((value) {
            if (value = true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const ShopTabScreen(screenId: 3)));
            }
          });
        },
      ),
    );
  }
}
