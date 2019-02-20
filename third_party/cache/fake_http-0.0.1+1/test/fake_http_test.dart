import 'package:test/test.dart';

import 'package:fake_http/fake_http.dart';
import 'package:intl/intl.dart';

void main() {
  print('${Directory.current} - ${Directory.systemTemp}');

  Directory directory =
      new Directory(join(Directory.current.path, 'build', 'cache'));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  OkHttpClient client = new OkHttpClientBuilder()
      .cache(new Cache(DiskCache.create(() => Future.value(directory))))
      .cookieJar(PersistentCookieJar.persistent(CookiePersistor.MEMORY))
      .addInterceptor(new UserAgentInterceptor(() => Future.value(Version.userAgent())))
      .addInterceptor(new OptimizedCacheInterceptor(() => Future.value(true)))
      .addNetworkInterceptor(new OptimizedResponseInterceptor())
      .addNetworkInterceptor(
          new HttpLoggingInterceptor(level: LoggerLevel.BODY))
      .addNetworkInterceptor(new ProgressRequestInterceptor((String url,
          String method, int progressBytes, int totalBytes, bool isDone) {
        print(
            'progress request - $method $url $progressBytes/$totalBytes done:$isDone');
      }))
      .addNetworkInterceptor(new ProgressResponseInterceptor((String url,
          String method, int progressBytes, int totalBytes, bool isDone) {
        print(
            'progress response - $method $url $progressBytes/$totalBytes done:$isDone');
      }))
      .build();

  test('smoke test - http get', () async {
    print('${new DateTime.now().toLocal()}');
    HttpUrl url = HttpUrl.parse('https://www.baidu.com/');
    Request request = new RequestBuilder().url(url).get().build();
    await client.newCall(request).enqueue().then((Response response) async {
      print('resp: ${response.code()} - ${response.message()} - ${(await response.body().string())}');
    }).catchError((error) {
      print('error: $error');
    });
    print('${new DateTime.now().toLocal()}');
  });

  test('smoke test - http get json', () async {
    print('${new DateTime.now().toLocal()}');
    HttpUrl url =
        HttpUrl.parse('https://www.apiopen.top/satinApi?type=1&page=1');
    Request request = new RequestBuilder().url(url).get().build();
    await client.newCall(request).enqueue().then((Response response) async {
      print(
          'resp: ${response.code()} - ${response.message()} - ${(await response.body().string())}');
    }).catchError((error) {
      print('error: $error');
    });
    print('${new DateTime.now().toLocal()}');
  });
}
