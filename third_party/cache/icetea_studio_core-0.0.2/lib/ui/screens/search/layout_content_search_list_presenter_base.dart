
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:icetea_studio_core/ui/base/base_presenter.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_content_layout_content_presenter_contract.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_contract.dart';
import 'package:icetea_studio_core/ui/view_models/list/base_list_vm.dart';
import 'package:icetea_studio_core/ui/view_models/list_item/list_item_base_vm_contract.dart';

abstract class SearchListContentBasePresenter<T extends IListLayout<BaseListVM<ListItemBaseVM>>>
    extends BasePresenter<T> implements IListContentLayoutContentPresenter {

  var batchIndex = 0,
      _isEndOfList = false,
      _isRefreshing = false,
      _userId;

  T _view;

  String get userId => _userId;
  T get view => _view;

  bool get isRefreshing => _isRefreshing;
  set isRefreshing(bool isRefreshing) => _isRefreshing = isRefreshing;

  bool get isEndOfList => _isEndOfList;
  set isEndOfList(bool isEnd) => _isEndOfList = isEnd;

  refreshContentList();
  searchProximity();
  searchByKeyword(String keyword);
  reInitializeList();
  initEventHandlers();

  resetLayoutState(){
    _isEndOfList = false;
    _isRefreshing = false;
    batchIndex = 0;
  }

  @override
  void resetContentList() {
    try {
      resetLayoutState();
      reInitializeList();
      view.onListLoading();
    } catch(e){
      handleError(e);
    }
  }

  @override
  void initializeContent() {

  }

  @override
  void search(String keyword){
    resetLayoutState();

    if(keyword != null && keyword.isNotEmpty){
      searchByKeyword(keyword);
    } else {
      searchProximity();
    }
  }

  @override
  void refreshList() {
    // TODO: implement refreshList
    _isRefreshing = true;
    refreshContentList();
  }

  SearchListContentBasePresenter(T view, String tag, String userId, {LoggerManager logger}):super(view, tag, logger){
    _view = view;
    _userId = userId;
    searchProximity();
    initEventHandlers();
  }
}