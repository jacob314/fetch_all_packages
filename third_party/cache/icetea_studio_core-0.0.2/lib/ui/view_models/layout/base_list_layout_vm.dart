
import 'package:icetea_studio_core/ui/view_models/layout/base_layout_vm.dart';

class BaseListLayoutVM extends IBaseLayoutVM {
  int _resultCount;
  int get resultCount => _resultCount;
  set resultCount(int resultCount) => _resultCount = resultCount;

  bool _loadMoreFromTop = false;
  bool get loadMoreFromTop => _loadMoreFromTop;
  set loadMoreFromTop(bool loadMoreFromTop) => _loadMoreFromTop = loadMoreFromTop;

  bool _isSearchAvailable;
  bool get isSearchAvailable => _isSearchAvailable;
  set isSearchAvailable(bool isSearchAvailable) => _isSearchAvailable = isSearchAvailable;
}



