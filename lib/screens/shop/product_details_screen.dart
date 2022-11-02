// ignore_for_file: prefer_typing_uninitialized_variables

import '../../provider/shop.dart';
import 'cartscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final productId;
  const ProductDetailsScreen(this.productId, {Key? key}) : super(key: key);

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}

class ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product _productDetails;
  var _isLoading = false;
  var _isInCart = false;
  @override
  void initState() {
    _isLoading = true;
    Provider.of<Shop>(context, listen: false)
        .fetchProductById(widget.productId)
        .then((value) {
      _productDetails = value;
      _isInCart = Provider.of<Shop>(context, listen: false)
          .findCartItem(_productDetails.id!);
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  addCartItem(productId, productName) {
    final val = Provider.of<Shop>(context, listen: false)
        .addCartItem(productId, 1, productName);
    if (val) {
      setState(() {
        _isInCart = Provider.of<Shop>(context, listen: false)
            .findCartItem(_productDetails.id!);
      });
    }
  }

  final imageList = [
    'https://rukminim1.flixcart.com/image/416/416/jyq5oy80/shampoo/n/2/z/650-cool-menthol-shampoo-650-ml-head-shoulders-original-imafgwfx4tedq2sy.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/q/m/a/cool-menthol-shampoo-head-shoulders-original-imafxywuseszwtzy.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/w/t/t/cool-menthol-shampoo-head-shoulders-original-imafxywuzz4svrge.jpeg?q=70',
    'https://rukminim1.flixcart.com/image/416/416/ki3gknk0-0/shampoo/b/s/e/cool-menthol-shampoo-head-shoulders-original-imafxywuykbd7upa.jpeg?q=70',
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procuct Details Screen'),
      ),
      bottomNavigationBar: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 55,
            width: deviceSize.width / 2,
            child: Center(
              child: TextButton(
                child: Text(
                  _isInCart ? 'GO TO CART' : 'ADD TO CART',
                  style: const TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  _isInCart
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()))
                      : addCartItem(_productDetails.id, _productDetails.name);
                },
              ),
            ),
          ),
          SizedBox(
            height: 55,
            width: deviceSize.width / 2,
            child: const Center(
              child: Text(
                'BUY NOW',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
            children: [
              SizedBox(
                height: deviceSize.height * 0.5,
                child: Swiper(
                  itemCount: imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(imageList[index]);
                  },
                  pagination: const SwiperPagination(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  _productDetails.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: const Text(
                  'Rs.135',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Highlights',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Anti-dandruff Shampoo',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Ideal For:Men & Women',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Suitable For :Frizzy Hair',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Composition:NA',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
