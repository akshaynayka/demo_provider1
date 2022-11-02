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

class CategoryListTile extends StatelessWidget {
  final String? type;

  const CategoryListTile({Key? key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<Category>(context, listen: false);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.category, size: 40.0),
        title: Text(categoryData.name),
        subtitle: Text(categoryData.status),
        trailing: Consumer<Category>(
          builder: (ctx, _, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton(
                onSelected: (MoreOptions selectedValue) async {
                  if (selectedValue == MoreOptions.Delete) {
                    final response =
                        await Provider.of<Shop>(context, listen: false)
                            .deleteCategory(categoryData.id!, context);
                    if (response) {
                      
                      displaySnackbar(context, TITLE_CATEGORY, TITLE_DELETED);
                      
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const ShopTabScreen(screenId: 2)));
                    }
                  } else {
                    Navigator.of(context)
                        .pushNamed(APP_ROUTE_ADD_EDIT_CATEGORY, arguments: {
                      'id': categoryData.id,
                    }).then((value) {
                      if (value != null && value != '') {
                        displaySnackbar(context, TITLE_CATEGORY, value);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) =>
                                const ShopTabScreen(screenId: 2)));
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
            APP_ROUTE_CATEGORY_DETAIL,
            arguments: {'id': categoryData.id, 'type': type},
          ).then((value) {
            if (value == true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const ShopTabScreen(screenId: 2)));
            }
          });
        },
      ),
    );
  }
}
