// ignore_for_file: prefer_typing_uninitialized_variables

import '../../../common_methods/common_methods.dart';
import '../../../provider/shop.dart';
import '../../../widgets/brandlist_tile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../values/strings_en.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({Key? key}) : super(key: key);

  @override
  BrandScreenState createState() => BrandScreenState();
}

class BrandScreenState extends State<BrandScreen> {
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
        .fetchAllBrands(page, context: context);
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

    final brands = Provider.of<Shop>(context, listen: false).brandList;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: deviceSize.height >= 650
                ? deviceSize.height * 0.79
                : deviceSize.height * 0.55,
            child: brands.isEmpty
                ? const Center(child: Text(TITLE_NO_DATA_AVAILABLE))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: brands.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ChangeNotifierProvider.value(
                      value: brands[index],
                      child: const BrandListTile(type: 'all'),
                    ),
                  ),
          );
  }
}
