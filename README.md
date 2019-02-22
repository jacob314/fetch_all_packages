# fetch_all_packages
Utility to scrape all pub packages that use Flutter.

# Example usage

## Use a cached copy of all pub packages
The cache has all 1608 pub packages that use flutter that were uploaded as of 2/22/2019.

```
git clone https://github.com/jacob314/fetch_all_packages
git checkout origin/with_cache 

cd third_party/cache/

git grep informationCollector -- '*.dart'
```
This example shows all uses of informationCollector across pub packages that use flutter. For this case you will likely see 13 uses which could help evaluate the impact of of making a breaking change to the API. `git grep` is quite fast so you will get answers to typical regexp based searches in only a couple seconds. In the future it would be nice to make it easy to run the dart analyzer and linter over all packages in the cache to evaluate the impact of more subtle breaking changes.

## Manually fetch the latest pub packages
Warning: this may take an hour even on a fast network.

```
git clone https://github.com/jacob314/fetch_all_packages
pub get
dart bin/scrape.dart
```

Thanks [munificent](https://github.com/munificent) for writing the core code to fetch dart packages programmatically!
