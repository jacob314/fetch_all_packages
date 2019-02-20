import 'package:woo_commerce_api_dart/woo_commerce_api.dart';

void main() {
  final wcApi = WooCommerceAPI(
      "http://www.bookinthecity.com", "ck_xxxxxxxxx", "cs_xxxxxxxxx");

  wcApi.getAsync('products/categories').then((response) {
    print(response);
  });

  wcApi.postAsync('customers', {
    "email": 'john.doe@example.com',
    "first_name": 'John',
    "last_name": 'Doe',
    "username": 'john.doe',
    "password": 'xxxx'
  }).then((response) {
    print(response);
  });
}
