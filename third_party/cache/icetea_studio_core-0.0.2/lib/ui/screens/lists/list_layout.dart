import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_content_presenter_contract.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_contract.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_presenter.dart';
import 'package:icetea_studio_core/ui/view_models/layout/base_list_layout_vm.dart';
import 'package:icetea_studio_core/ui/view_models/list/base_list_vm.dart';
import 'package:icetea_studio_core/ui/widgets/inputs/search_filter_input.dart';
import 'package:icetea_studio_core/ui/widgets/load_more/load_more_item.dart';
import 'package:icetea_studio_core/ui/widgets/state/error_view/error_view.dart';

//abstract class ListLayoutState<T extends StatefulWidget, V extends BaseListVM, W extends BaseListLayoutVM> extends BaseLayoutState<T, V, W> implements IListLayout<V, W> {
abstract class ListLayoutState<T extends StatefulWidget, V extends BaseListVM, W extends BaseListLayoutVM> extends BaseLayoutState<T, V, W> implements IListLayout<V> {

  /// Define a List-Layout-specific Layout presenter

  @override
  ListLayoutPresenter get layoutPresenter;

  /// Define a List-Layout-specific Content presenter
  /// The content's presenter that contains specific implementation for the [IListLayoutContentPresenter] interface used by the layout to respond to a user's interaction
  ///
  /// e.g. Filter the list of results; Refresh the list; Load new batch on scroll
  @override
  IListLayoutContentPresenter get contentPresenter;

  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scrollController = new ScrollController();

  bool _isPerformingRequest = false;
  bool _isAllowLoadMore = true;

  ListLayoutState() {
    super.layoutPresenter = ListLayoutPresenter(this, 'ListLayout', null);
  }

  @override
  void onBatchContentLoadedOnScroll(bool isEnd) {
    _isAllowLoadMore = !isEnd;
    setState(() {
      _isPerformingRequest = false;
      body = buildContent(context);
    });
  }

  @override
  void onListInitialized(bool isEnd) {
    _isAllowLoadMore = !isEnd;

    setState(() {
      layoutPresenter.initializeLayoutModel();
      body = buildContent(context);
    });
  }

  @override
  void onListRefreshedComplete() {
    _isPerformingRequest = false;
    setState(() {
      layoutPresenter.initializeLayoutModel();
      body = buildContent(context);
    });
  }

  @override
  void onListLoading(){
    super.onContentLoading();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !_isPerformingRequest && _isAllowLoadMore) {
        _isPerformingRequest = true;
        contentPresenter.loadNextBatch();
      }
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    try {
      return _buildContainerView(context);
    } catch(e){
      return Container();
    }
  }

  // Members to be overriden by child pages
  String getEmptyContentMsg(BuildContext context);
  Widget buildItemBuilder(BuildContext context, int index);

  _buildContainerView(BuildContext context) {
    return new Container(
      child: new RefreshIndicator(
        key: _refreshKey,
        child: new Stack(
          children: () {
            var children = <Widget>[
              _buildListView(context),
            ];

            if (lModel != null && lModel.isSearchAvailable == true) {
              children.add(_buildSearchView());
            }

            return children;
          }(),
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  _buildSearchView() {
    return new SearchInputFilter(onChanged: (String keyword) {
      contentPresenter.getSuggestions(keyword);
    }, hintText: "");
  }

  Widget get emptyListView => _buildEmptyListView();

  _buildEmptyListView() {
    return new Center(child: new ErrorView(lModel.isSearchAvailable != null ? "" : getEmptyContentMsg(context), onErrorViewInteraction: () {
      _handleRefresh();
    }));
  }

  _buildList(int count){
    return new Container(
      margin: new EdgeInsets.only(top: (lModel != null && lModel.isSearchAvailable == true ? 80.0 : 10.0)),
      child: ListView.builder(
        itemCount: count,
        itemBuilder: _buildItemBuilder,
        controller: _scrollController,
      ),
    );
  }

  _buildListView(BuildContext context) {
    print('build list ${model.items.length}');
    int count = 0;

    if (model != null && model.items != null && model.items.length != 0) {
      count = model.items.length;
    }

    if (_isAllowLoadMore) {
      count++;
    }

    return (model == null || model.items == null || model.items.length == 0)
        ? emptyListView: _buildList(count);
  }

  Widget _buildItemBuilder(BuildContext context, int index) {
    if (index == model.items.length && _isAllowLoadMore) {
      return new LoadMoreItem();
    } else {
      return buildItemBuilder(context, index);
    }
  }

  Future<Null> _handleRefresh() async {
    _refreshKey.currentState?.show();
    _isPerformingRequest = true;
    _isAllowLoadMore = true;
    await new Future.delayed(new Duration(seconds: 2));
    contentPresenter.refreshList();
    return null;
  }
}
