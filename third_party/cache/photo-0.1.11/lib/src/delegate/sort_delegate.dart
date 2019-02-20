import 'package:photo_manager/photo_manager.dart';

abstract class SortDelegate {
  const SortDelegate();

  void sort(List<AssetPathEntity> list);

  static const none = DefaultSortDelegate();

  static const common = CommonSortDelegate();
}

class DefaultSortDelegate extends SortDelegate {
  const DefaultSortDelegate();

  @override
  void sort(List<AssetPathEntity> list) {}
}

class CommonSortDelegate extends SortDelegate {
  const CommonSortDelegate();

  @override
  void sort(List<AssetPathEntity> list) {
    list.sort((path1, path2) {
      if (path1 == AssetPathEntity.all) {
        return -1;
      }

      if (path2 == AssetPathEntity.all) {
        return 1;
      }

      if (_isCamera(path1)) {
        return -1;
      }

      if (_isCamera(path2)) {
        return 1;
      }

      if (_isScreenShot(path1)) {
        return -1;
      }

      if (_isScreenShot(path2)) {
        return 1;
      }

      return otherSort(path1, path2);
    });
  }

  int otherSort(AssetPathEntity path1, AssetPathEntity path2) {
    return path1.name.compareTo(path2.name);
  }

  bool _isCamera(AssetPathEntity entity) {
    return entity.name.toUpperCase() == "camera".toUpperCase();
  }

  bool _isScreenShot(AssetPathEntity entity) {
    return entity.name.toUpperCase() == "screenshots".toUpperCase() ||
        entity.name.toUpperCase() == "screenshot".toUpperCase();
  }
}
