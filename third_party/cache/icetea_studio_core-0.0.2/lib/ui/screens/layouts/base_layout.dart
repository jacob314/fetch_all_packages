import 'package:flutter/material.dart';
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:icetea_studio_core/ui/base/base_state.dart';
import 'package:icetea_studio_core/ui/base/base_view_model.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_content_presenter_contract.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_contract.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_presenter.dart';
import 'package:icetea_studio_core/ui/view_models/layout/base_layout_vm.dart';

/// Defines the Base layout for all screens that have a Header and a Body
///
/// This layout class can be extended to support more specific layouts with specific Header, Body, and Footer Types.
/// The layout contains a [header] defining the layout's header's UI, a [body] defining the layout's body's UI , a [layoutPresenter] managing the View Model for the layout, and a [contentPresenter] - an interface used by the layout to communicate with the child screen
//abstract class BaseLayoutState<T extends StatefulWidget, V extends IBaseVM, W extends IBaseLayoutVM> extends BaseState<T, V> implements IBaseLayout<V, W>{
abstract class BaseLayoutState<T extends StatefulWidget, V extends IBaseVM, W extends IBaseLayoutVM> extends BaseState<T, V> implements IBaseLayout<V> {

  /// The title of the screen
  Widget header;

  W lModel;

  Widget _loadingIndicator = new Center(child: new CircularProgressIndicator(strokeWidth: 2.0,),);

  /// The content of the screen
  Widget body;

  LoggerManager _logger;

  BaseLayoutPresenter _layoutPresenter;
  BaseLayoutPresenter get layoutPresenter => _layoutPresenter;
  set layoutPresenter(BaseLayoutPresenter p) => _layoutPresenter = p;

  /// The content's presenter that contains specific implementation for the [IBaseLayoutContentPresenter] interface used by the layout to respond to a user's interaction
  ///
  /// e.g. Filter the list of results; Refresh the list; Load new batch on scroll
  IBaseLayoutContentPresenter _contentPresenter;
  IBaseLayoutContentPresenter get contentPresenter => _contentPresenter;
  /// Called by the child screen to register the content presenter
  set contentPresenter(IBaseLayoutContentPresenter p) => _contentPresenter = p;


  BaseLayoutState(){
    body = _loadingIndicator;
    _layoutPresenter = BaseLayoutPresenter(this, 'BaseLayout', _logger);
  }


  /// Provides an interface for the child page to provide a title to the layout to use.
  String getTitle(BuildContext context);

  /// Provides an interface for the child page to provide a content widget to the layout
  ///
  /// The layout is responsible for when it is ready to update the tree with the content
  Widget buildContent(BuildContext context);

  /// Provides a way to child page to control if it wants the layout to initialize with the content available
  ///
  /// Available contents include the layout's UI contents
  void initPage() {
    setState((){});
  }

  Widget _buildTitle(BuildContext context){
    return Text(getTitle(context));
  }


  @override
  Widget build(BuildContext context) {
    header = _buildTitle(context);

    return new Scaffold(
      appBar: new AppBar(
        title: header,
      ),
      body:body,
    );
  }

  @override
  void onContentInitialized() {
    setState(() {
      body = buildContent(context);
    });
  }

  @override
  void onContentLoading(){
    setState(() {
      body = _loadingIndicator;
    });
  }
}
