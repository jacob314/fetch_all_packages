https://pub.dartlang.org/packages/intl
https://www.youtube.com/watch?v=IhsHGJEOSYM
https://gist.github.com/tensor-programming/d53e7da4a609cef640881ca30dbf3982
https://github.com/konifar/droidkaigi2018-flutter/blob/master/lib/i18n/REGENERATE.md

```
flutter packages pub run intl_translation:extract_to_arb --output-dir=lib/ui/i18n lib/ui/i18n/strings.dart
```

To rebuild the i18n files:

```
flutter packages pub run intl_translation:generate_from_arb \  
   --output-dir=lib/i18n  \
  --no-use-deferred-loading  \
  lib/i18n/*.dart  \
  lib/i18n/*.arb 

flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/ui/i18n --no-use-deferred-loading lib/ui/i18n/intl_*.arb lib/ui/i18n/strings.dart

  
```
