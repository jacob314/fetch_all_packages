import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/screens/dialog/dialog_layout.dart';
import 'package:icetea_studio_core/ui/view_models/dialog/base_dialog_vm.dart';

abstract class DialogWithActionLayoutState<T extends StatefulWidget, V extends IBaseDialogVM>
    extends DialogLayoutState<T, V> {

  final IconData actionIcon = Icons.done;
  void doAction();

  @override
  buildAppBar() {
    return new AppBar(
      elevation: 1.0,
      leading: new IconButton(
          icon: new Icon(Icons.close,
              color: Theme.of(context).accentIconTheme.color
          ),
          onPressed: close
      ),
      title: new Text(getTitle(context)),
      actions: model.isShowAction ? [
        new IconButton(
          icon: new Icon(actionIcon),
          onPressed: () => doAction(),
        )
      ] : []
    );
  }

  @override
  void showAction() {
    setState((){

      // Rebuild the body with the change.
      // NOTE: Typically we want the base layout to initiate the rebuild and the child will build the content for the layout

      body = buildContent(context);
      model.isShowAction = true;
    });
  }
}