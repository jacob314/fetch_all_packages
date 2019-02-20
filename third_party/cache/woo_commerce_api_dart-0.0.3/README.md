# woocommerce_api

A dart package to interact with the WooCommerce API. It uses OAuth1.0a behind the scenes to generate the signature and URL string. It then makes calls and return the data back to the calling function.

## Getting Started

* Import the package

`import 'package:woo_commerce_api_dart/woo_commerce_api.dart';`

* Initialize the SDK

```
WooCommerceAPI wcApi = new WooCommerceAPI(
    "http://www.mywoocommerce.com",
    "ck_...",
    "cs_..."
);
```

* Use functions

```
List _products = new List();

wcApi.getAsync("products?page=2").then((val) {
    List parsedMap = val;
    setState(() {
    parsedMap.forEach((f){
        _products.add(f);
    });
    print(_products.length);
    });
});
```
