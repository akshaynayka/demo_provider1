import '../../provider/shop.dart';
import '../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static getSizedBox({double? width, double? height}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  Widget createCartListItem(String itemId, String itemName, String quentity) {
    return Stack(
      children: <Widget>[
        Container(
          height: 110,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://rukminim1.flixcart.com/image/416/416/jyq5oy80/shampoo/n/2/z/650-cool-menthol-shampoo-650-ml-head-shoulders-original-imafgwfx4tedq2sy.jpeg?q=70"),
                  ),
                ),
              ),
              Expanded(
                flex: 100,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          itemName,
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      CartScreen.getSizedBox(height: 6),
                      const Text(
                        "size or varient",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Rs.299.00",
                            style: TextStyle(color: Colors.green),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  onPressed: () {
                                    Provider.of<Shop>(context, listen: false)
                                        .addRemoveCartItem(itemId, 'remove');
                                    setState(() {});
                                  }),
                              Container(
                                color: Colors.grey.shade200,
                                padding: const EdgeInsets.only(
                                    right: 12, left: 12),
                                child: Text(
                                  quentity,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  onPressed: () {
                                    Provider.of<Shop>(context, listen: false)
                                        .addRemoveCartItem(itemId, 'add');
                                    setState(() {});
                                  })
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 30,
            height: 30,
            // alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10, top: 8),
            padding: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Theme.of(context).primaryColor),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                // size: 20,
              ),
              onPressed: () {
                Provider.of<Shop>(context, listen: false)
                    .deleteCartItem(itemId);
                setState(() {});
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemList = Provider.of<Shop>(context, listen: false).cartItemList;
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_SHOPPING_CART),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 12, top: 4),
                  child: const Text("Total(3) Items :",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(right: 12, top: 4),
                  child: const Text("Rs. 2400", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            SizedBox(
              height: 600,
              child: cartItemList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItemList.length,
                      // scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return createCartListItem(
                          cartItemList[index].productId,
                          cartItemList[index].productName,
                          cartItemList[index].quantity.toString(),
                        );
                      })
                  : const Text(TITLE_CART_IS_EMPTY),
            ),
          ],
        ),
      ),
    );
  }
}
