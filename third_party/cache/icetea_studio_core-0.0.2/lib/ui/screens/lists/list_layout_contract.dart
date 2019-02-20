

import 'package:icetea_studio_core/ui/screens/layouts/base_layout_contract.dart';
import 'package:icetea_studio_core/ui/view_models/list/base_list_vm.dart';

/// ListLayout Interface
/// 
/// Provides the communication channel between the MainLayout and the [MainLayoutPresenter]
//abstract class IListLayout<T extends BaseListVM, W extends BaseListLayoutVM> extends IBaseLayout<T, W>{
abstract class IListLayout<T extends BaseListVM> extends IBaseLayout<T> {

  /// When refreshing the content list is completed
  void onListLoading();
  void onListRefreshedComplete();
  void onListInitialized(bool isEnd);
  void onBatchContentLoadedOnScroll(bool isEnd);
  void onSearchStarted(String keyword);
}
