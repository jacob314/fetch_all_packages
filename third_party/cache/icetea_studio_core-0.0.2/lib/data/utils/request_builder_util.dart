
class RequestBuilderUtil {
    static String buildGetUrl(Map<String, dynamic> params) {
        if (params == null) {
            return "";
        }
        return params.keys.map((k) {
          if (k is Map){
            return '$k=${Uri.encodeComponent(params[k])}';
          }
          return '$k=${params[k]}';
        }).join("&");
    }
}
