// ignore_for_file: prefer_typing_uninitialized_variables

import '../../../common_methods/common_methods.dart';
import '../../../provider/shop.dart';
import '../../../widgets/productList_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../values/strings_en.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  var _isInit = true;
  var _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  var _page;
  var _lastpage;

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  getPages(page) async {
    _page = page;
    final pageResponse = await Provider.of<Shop>(context, listen: false)
        .fetchAllProducts(page, context: context);
    _page = pageResponse['currentPage'];
    _lastpage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _page = 1;

    getPages(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _page <= _lastpage) {
        _page++;
        getPages(_page);
      }
    });


    setScreenValue('3');

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Shop>(context).rebuildWidget(context: context);
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final products = Provider.of<Shop>(context, listen: false).productList;
    return _isLoading
        ? const Center(child:  CircularProgressIndicator())
        : SizedBox(
            height: deviceSize.height >= 650
                ? deviceSize.height * 0.79
                : deviceSize.height * 0.55,
            child: products.isEmpty
                ? const Center(child: Text(TITLE_NO_DATA_AVAILABLE))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ChangeNotifierProvider.value(
                      value: products[index],
                      child: const ProductListTile(type: 'all'),
                    ),
                  ),
          );
  }
}
