import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_content_presenter_contract.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_presenter.dart';
import 'package:icetea_studio_core/ui/view_models/layout/base_list_layout_vm.dart';
import 'package:icetea_studio_core/ui/view_models/list/base_list_vm.dart';

/// Layout for a displaying a list in the content of another layout (i.e. [TabSearchLayout])
abstract class  ContentListLayoutState<T extends StatefulWidget, V extends BaseListVM, W extends BaseListLayoutVM> extends ListLayoutState<T, V, W> with RouteAware{

  IListLayoutContentPresenter get contentPresenter;
  bool isProximitySearch;

  ContentListLayoutState(){
    layoutPresenter = ListLayoutPresenter(this, 'ContentListLayout', null);
  }

  @override
  Widget build(BuildContext context) {

    // Return the body part only
    return body;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onSearchStarted(String keyword) {
    isProximitySearch = (keyword == null || keyword.isEmpty)? true:false;
  }
}