import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/screens/dialog/dialog_layout_content_presenter_contract.dart';
import 'package:icetea_studio_core/ui/screens/dialog/dialog_layout_contract.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout.dart';
import 'package:icetea_studio_core/ui/view_models/dialog/base_dialog_vm.dart';

abstract class DialogLayoutState<T extends StatefulWidget, V extends IBaseDialogVM>
    extends BaseLayoutState<T, V, V> implements IDialogLayout<V> {

  /*@override
  DialogLayoutPresenter get layoutPresenter;*/

  @override
  IDialogLayoutContentPresenter get contentPresenter;

  Widget buildAppBar() {
    ModalRoute route = ModalRoute.of(context);
    bool isFullscreenDialog = route is PageRoute ? route.fullscreenDialog : false;

    return new AppBar(
      elevation: 1.0,
      leading: new IconButton(
          icon: new Icon(isFullscreenDialog ? Icons.close : Icons.arrow_back,
              color: Theme.of(context).accentIconTheme.color
          ),
          onPressed: close
      ),
      title: new Text(getTitle(context))
    );
  }

  @override
  V lModel;

  @override
  void close([dynamic result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(),
      body: body,
    );
  }
}