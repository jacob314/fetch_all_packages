import 'package:odoo_api/odoo_api.dart';

main() {
  var client = OdooClient("http://yourdomain.com");
  client.connect().then((version) {
    print("Connected ${version}");
  });
}
