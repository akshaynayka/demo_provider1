import '../../screens/shop/brand/brands_screen.dart';
import 'cartscreen.dart';
import '../../screens/shop/category/category_screen.dart';
import '../../screens/shop/product/product_screen.dart';
import '../../screens/shop/shop_home_screen.dart';
import '../../widgets/shop_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../values/strings_en.dart';
import '../../widgets/side_drawer.dart';

class ShopTabScreen extends StatefulWidget {
  final int? screenId;
  const ShopTabScreen({Key? key, this.screenId}) : super(key: key);

  @override
  ShopTabScreenState createState() => ShopTabScreenState();
}

class ShopTabScreenState extends State<ShopTabScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': const ShopHomeScreen(),
      'title': dotenv.get('APP_TITLE'),
    },
    {
      'page':const BrandScreen(),
      'title': TITLE_BRANDS,
    },
    {
      'page':const CategoryScreen(),
      'title': TITLE_CATEGORIES,
    },
    {
      'page': const ProductScreen(),
      'title': TITLE_PRODUCTS,
    },
  ];

  int _selectedPageIndex = 0;

  @override
  void initState() {
    if (widget.screenId != null) {
      _selectedPageIndex = widget.screenId!;
    }

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_SHOP),
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartScreen()));
              })
        ],
      ),
      drawer: const SideDrawer(),
      floatingActionButton: const ShopFloatingActionWidget(),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items:const [
          BottomNavigationBarItem(
            label: TITLE_HOME,
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: TITLE_BRANDS,
            icon: Icon(Icons.alarm),
          ),
          BottomNavigationBarItem(
            label: TITLE_CATEGORIES,
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            label: TITLE_PRODUCTS,
            icon: Icon(Icons.shop_two),
          ),
        ],
      ),
    );
  }
}
