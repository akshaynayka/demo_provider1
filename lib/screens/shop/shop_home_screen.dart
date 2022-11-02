// ignore_for_file: prefer_typing_uninitialized_variables

import '../../provider/shop.dart';
import '../../screens/shop/product_details_screen.dart';
import '../../values/strings_en.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({Key? key}) : super(key: key);

  @override
  ShopHomeScreenState createState() => ShopHomeScreenState();
}

class ShopHomeScreenState extends State<ShopHomeScreen> {
  final imageList = [
    'https://rukminim1.flixcart.com/image/416/416/jyq5oy80/shampoo/n/2/z/650-cool-menthol-shampoo-650-ml-head-shoulders-original-imafgwfx4tedq2sy.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/q/m/a/cool-menthol-shampoo-head-shoulders-original-imafxywuseszwtzy.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/w/t/t/cool-menthol-shampoo-head-shoulders-original-imafxywuzz4svrge.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/b/s/e/cool-menthol-shampoo-head-shoulders-original-imafxywuykbd7upa.jpeg?q=70',
  ];
  var _isLoading = false;

  final ScrollController _brandScrollController = ScrollController();
  var _brandCurrentPage;
  var _brandLastpage;

  final ScrollController _categoryScrollController = ScrollController();
  var _categoryCurrentPage;
  var _categoryLastPage;

  getBrandPages(page) async {
    _brandCurrentPage = page;
    final pageResponse = await Provider.of<Shop>(context, listen: false)
        .fetchAllBrands(page, context: context);
    _brandCurrentPage = pageResponse['currentPage'];
    _brandLastpage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  getCategoryPages(page) async {
    _categoryCurrentPage = page;
    final pageResponse = await Provider.of<Shop>(context, listen: false)
        .fetchAllCategories(page, context: context);
    _categoryCurrentPage = pageResponse['currentPage'];
    _categoryLastPage = pageResponse['lastPage'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _brandScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _brandCurrentPage = 1;
    _categoryCurrentPage = 1;

    getBrandPages(_brandCurrentPage);
    getCategoryPages(_categoryCurrentPage);

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
              _brandScrollController.position.maxScrollExtent &&
          _brandCurrentPage <= _brandLastpage) {
        _brandCurrentPage++;
        getBrandPages(_brandCurrentPage);
      }
    });

    _categoryScrollController.addListener(() {
      if (_categoryScrollController.position.pixels ==
              _categoryScrollController.position.maxScrollExtent &&
          _categoryCurrentPage <= _categoryLastPage) {
        _categoryCurrentPage++;
        getCategoryPages(_categoryCurrentPage);
      }
    });

    Provider.of<Shop>(context, listen: false).fetchAllProducts(1).then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brandList = Provider.of<Shop>(context, listen: false).brandList;
    final categoryList = Provider.of<Shop>(context, listen: false).categoryList;
    final productList = Provider.of<Shop>(context, listen: false).productList;

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  SizedBox(
                    height: deviceSize.height * 0.13,
                    child: brandList.isNotEmpty
                        ? ListView.builder(
                            controller: _brandScrollController,
                            itemCount: brandList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: SizedBox(
                                  width: deviceSize.width / 6,
                                  // height: deviceSize.height / 11,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        'https://i.pinimg.com/564x/f8/ff/a2/f8ffa23f243e12e96a0dbf11d2fc1f4c.jpg',
                                        height: deviceSize.height / 11,
                                        width: deviceSize.width / 6,
                                      ),
                                      Text(
                                        brandList[index].name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text(TITLE_NO_BRAND_AVAILABLE)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 150,
                    child: categoryList.isNotEmpty
                        ? ListView.builder(
                            controller: _categoryScrollController,
                            itemCount: categoryList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 150,
                                // height: 68,
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.network(
                                        'https://rukminim1.flixcart.com/flap/128/128/image/69c6589653afdb9a.png?q=100',
                                        height: 100,
                                        width: 100,
                                      ),
                                      Text(categoryList[index].name),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text(TITLE_NO_CATEGORY_AVAILABLE)),
                  ),
                  SizedBox(
                    height: deviceSize.height / 1.6,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: deviceSize.height / 1.7,
                          color: const Color(0xffF5E4D2),
                        ),
                        Container(
                          height: deviceSize.height / 7,
                          width: deviceSize.width,
                          alignment: Alignment.topCenter,
                        ),
                        Positioned(
                          top: 15,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: deviceSize.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Text(
                                          'Popular Products',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xff2874F0)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'View All',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8, top: 8),
                                width: deviceSize.width,
                                height: deviceSize.height / 1.75,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  child: productList.isNotEmpty
                                      ? SingleChildScrollView(
                                          child: GridView.builder(
                                            padding: const EdgeInsets.all(10),
                                            shrinkWrap: true,
                                            itemCount: productList.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ProductDetailsScreen(
                                                                  productList[
                                                                          index]
                                                                      .id)));
                                                },
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.5,
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            7,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        child: Swiper(
                                                          itemCount:
                                                              imageList.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Image
                                                                .network(
                                                                    imageList[
                                                                        index]);
                                                          },
                                                          itemWidth: 100.0,
                                                          itemHeight: 100.0,
                                                          duration: 50,
                                                          autoplay: true,
                                                          // pagination: SwiperPagination(),
                                                          layout: SwiperLayout
                                                              .STACK,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                          productList[index]
                                                              .name,
                                                          style: const TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          'Rs.350',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2),
                                          ),
                                        )
                                      : const Center(
                                          child:
                                              Text(TITLE_NO_PRODUCT_AVAILABLE)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
