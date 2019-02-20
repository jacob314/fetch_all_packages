import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_content_presenter_contract.dart';

class LayoutTabContentInfo {
  Widget _content;
  IBaseLayoutContentPresenter _presenter;

  Widget get content => _content;
  IBaseLayoutContentPresenter get presenter => _presenter;

  LayoutTabContentInfo(this._content, this._presenter);
}