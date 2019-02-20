## [3.1.3]
* Fix Android 9.0 Pie KeyStore exception. Thanks to [hacker1024](https://github.com/hacker1024)

## [3.1.2]
* Added recreating secretKey if its decoding failed. Fix for [unwrap key](https://github.com/mogol/flutter_secure_storage/issues/13). Thanks to [hnvn](https://github.com/hnvn).

## [3.1.1]
* Suppress warning about unchecked operations when compiling for Android.

## [3.1.0]
* Added `readAll` and `deleteAll`.

## [3.0.0]
* **Breaking change**. Changed payloads encryption for Android from RSA to AES, AES secret key is encrypted with RSA. 

## [2.0.0]
* **Breaking change**. Changed key alias to fix Android 4.4.2 issue. The plugin isn't able to get previous stored data. 

## [1.0.0]
* Bump version

## [0.0.1]

* Initial release
