import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../http_request/http_request.dart';
import '../values/api_end_points.dart';
import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String? id;
  final String? clientId;
  final String? parentId;
  final String name;
  final String? description;
  final String? order;
  final String status;

  Category({
    required this.id,
    this.clientId,
    this.parentId,
    required this.name,
    required this.description,
    this.order,
    required this.status,
  });
}

class Brand with ChangeNotifier {
  final String? id;
  final String name;
  final String? description;
  final String status;

  Brand({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });
}

class Product with ChangeNotifier {
  final String? id;
  final String? clientId;
  final dynamic brand;
  final String name;
  final String? description;
  final String? order;
  final String status;

  Product({
    required this.id,
    required this.clientId,
    required this.brand,
    required this.name,
    required this.description,
    required this.order,
    required this.status,
  });
}

class CartItem {
  final String productId;
  final String productName;

  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
  });
}

class Shop with ChangeNotifier {
  final HttpRequest _httpRequest =  HttpRequest();
  // ignore: prefer_typing_uninitialized_variables
  final _authToken;

  Shop(this._authToken);
  List<Brand> _brandList = [];
  List<Category> _categoryList = [];
  List<Product> _productList = [];
  final List<CartItem> _cartItemList = [];

  List<Category> get categoryList {
    return [..._categoryList];
  }

  List<Brand> get brandList {
    return [..._brandList];
  }

  List<Product> get productList {
    return [..._productList];
  }

  List<CartItem> get cartItemList {
    return [..._cartItemList];
  }

  Future<void> rebuildWidget({BuildContext? context}) async {
    // print('---calling rebuild---');
  }

  Future<Map> fetchAllCategories(page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _categoryList = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_CATEGORIES,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Category> loadedData = [];
      extractedData['data']['categories']['data'].forEach((categoryData) {
        loadedData.add(Category(
          id: categoryData['id'].toString(),
          clientId: categoryData['client_id'].toString(),
          parentId: categoryData['parent_id'].toString(),
          name: categoryData['name'],
          description: categoryData['description'],
          order: categoryData['order'].toString(),
          status: categoryData['status'],
        ));
      });
      _categoryList = _categoryList + loadedData;

      pages['currentPage'] =
          extractedData['data']['categories']['current_page'];
      pages['lastPage'] = extractedData['data']['categories']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Category> fetchCategoryById(id, {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_CATEGORIES/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['category'];

      final categoryData = Category(
        id: extractedData['id'].toString(),
        name: extractedData['name'],
        description: extractedData['description'],
        status: extractedData['status'],
      );

      notifyListeners();
      return categoryData;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateCategory(String id, Category newCategory, context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          id,
          API_CATEGORIES,
          {
            'name': newCategory.name,
            'description': newCategory.description,
            'status': newCategory.status,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> addCategory(Category category, context) async {
    var status = false;
    try {
      final response = await _httpRequest.postRequest(
          API_CATEGORIES,
          {
            'name': category.name,
            'description': category.description,
            'status': category.status,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  deleteCategory(String id, context) async {
    var deleteStatus = false;

    final existingCategoryIndex =
        _categoryList.indexWhere((categoryData) => categoryData.id == id);
    Category? existingCategory = _categoryList[existingCategoryIndex];

    await _httpRequest
        .deleteRequest(
      '$API_CATEGORIES/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (json.decode(response.body)['success'] == true) {
        deleteStatus = true;
      } else {
        if (kDebugMode) {
          print('error occured!!');
        }
      }

      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingCategory = null;
    }).catchError((_) {
      _categoryList.insert(existingCategoryIndex, existingCategory!);
      notifyListeners();
      deleteStatus = false;
    });

    _categoryList.removeAt(existingCategoryIndex);
    notifyListeners();
    return deleteStatus;
  }

  Future<Map> fetchAllBrands(page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _brandList = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_BRANDS,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Brand> loadedData = [];
      extractedData['data']['brands']['data'].forEach((brandData) {
        loadedData.add(Brand(
          id: brandData['id'].toString(),
          name: brandData['name'],
          description: brandData['description'],
          status: brandData['status'],
        ));
      });
      _brandList = _brandList + loadedData;

      pages['currentPage'] = extractedData['data']['brands']['current_page'];
      pages['lastPage'] = extractedData['data']['brands']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Brand> fetchBrandById(id, {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_BRANDS/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['brand'];

      final brandData = Brand(
        id: extractedData['id'].toString(),
        name: extractedData['name'],
        description: extractedData['description'],
        status: extractedData['status'],
      );

      notifyListeners();
      return brandData;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateBrand(String id, Brand newBrand, context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          id,
          API_BRANDS,
          {
            'name': newBrand.name,
            'description': newBrand.description,
            'status': newBrand.status,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> addBrand(Brand brand, context) async {
    var status = false;
    try {
      final response = await _httpRequest.postRequest(
          API_BRANDS,
          {
            'name': brand.name,
            'description': brand.description,
            'status': brand.status,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  deleteBrand(String id, context) async {
    var deleteStatus = false;

    final existingBrandIndex =
        _brandList.indexWhere((brandData) => brandData.id == id);
    Brand? existingBrand = _brandList[existingBrandIndex];

    await _httpRequest
        .deleteRequest(
      '$API_BRANDS/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (json.decode(response.body)['success'] == true) {
        deleteStatus = true;
      } else {
        if (kDebugMode) {
          print('error occured!!');
        }
      }

      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingBrand = null;
    }).catchError((_) {
      _brandList.insert(existingBrandIndex, existingBrand!);
      notifyListeners();
      deleteStatus = false;
    });

    _brandList.removeAt(existingBrandIndex);
    notifyListeners();
    return deleteStatus;
  }

// -----------product data---------

  Future<Map> fetchAllProducts(page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _productList = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_PRODUCTS,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Product> loadedData = [];
      extractedData['data']['products']['data'].forEach((productData) {
        loadedData.add(Product(
          id: productData['id'].toString(),
          clientId: productData['client_id'].toString(),
          brand: productData['brand']['name'],
          name: productData['name'],
          description: productData['description'],
          order: productData['order'].toString(),
          status: productData['status'],
        ));
      });
      _productList = _productList + loadedData;

      pages['currentPage'] = extractedData['data']['products']['current_page'];
      pages['lastPage'] = extractedData['data']['products']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Product> fetchProductById(id, {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_PRODUCTS/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['product'];

      final productData = Product(
        id: extractedData['id'].toString(),
        clientId: extractedData['client_id'].toString(),
        brand: extractedData['brand'],
        name: extractedData['name'],
        description: extractedData['description'],
        order: extractedData['order'].toString(),
        status: extractedData['status'],
      );

      notifyListeners();
      return productData;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateProduct(String id, Product newProduct, context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          id,
          API_PRODUCTS,
          {
            'brand_id': newProduct.brand,
            'name': newProduct.name,
            'description': newProduct.description,
            'status': newProduct.status,
            'order': newProduct.order,
            'client_id': newProduct.clientId,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> addProduct(Product product, context) async {
    var status = false;
    try {
      final response = await _httpRequest.postRequest(
          API_PRODUCTS,
          {
            'brand_id': product.brand,
            'name': product.name,
            'description': product.description,
            'status': product.status,
            // 'order': product.order,
            // 'client_id': product.clientId,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  deleteProduct(String id, context) async {
    var deleteStatus = false;

    final existingProductIndex =
        _productList.indexWhere((productData) => productData.id == id);
    Product? existingProduct = _productList[existingProductIndex];

    await _httpRequest
        .deleteRequest(
      '$API_PRODUCTS/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (json.decode(response.body)['success'] == true) {
        deleteStatus = true;
      } else {
        if (kDebugMode) {
          print('error occured!!');
        }
      }

      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingProduct = null;
    }).catchError((_) {
      _productList.insert(existingProductIndex, existingProduct!);
      notifyListeners();
      deleteStatus = false;
    });

    _productList.removeAt(existingProductIndex);
    notifyListeners();
    return deleteStatus;
  }

  bool addCartItem(
    String productId,
    int quantity,
    String productName,
  ) {

    _cartItemList.add(CartItem(
      productId: productId,
      productName: productName,
      quantity: 1,
    ));

    notifyListeners();
    return true;
  }

  bool findCartItem(
    String productId,
  ) {
    final existingCartIndex =
        _cartItemList.indexWhere((data) => data.productId == productId);

    if (existingCartIndex > -1) {
      return true;
    }
    return false;
  }

  addRemoveCartItem(String productId, String action) {
    final existingCartIndex =
        _cartItemList.indexWhere((data) => data.productId == productId);
    final existingCartItem = _cartItemList[existingCartIndex];
    if (action == 'add') {
      _cartItemList[existingCartIndex] = CartItem(
        productId: existingCartItem.productId,
        productName: existingCartItem.productName,
        quantity: existingCartItem.quantity + 1,
      );
    } else if (existingCartItem.quantity > 1) {
      _cartItemList[existingCartIndex] = CartItem(
        productId: existingCartItem.productId,
        productName: existingCartItem.productName,
        quantity: existingCartItem.quantity - 1,
      );
    }
  }

  deleteCartItem(String productId) {
    final existingCartIndex =
        _cartItemList.indexWhere((data) => data.productId == productId);

    if (existingCartIndex > -1) {
      _cartItemList.removeAt(existingCartIndex);
    }
  }
}
