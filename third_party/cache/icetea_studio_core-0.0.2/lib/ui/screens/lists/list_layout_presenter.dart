

import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_presenter.dart';
import 'package:icetea_studio_core/ui/screens/lists/list_layout_contract.dart';

/// The presenter of the [ListLayout] view
///
/// Responsible for the View Model and View Logics for the Layout UI components.
/// Ex: Update the # of list items displayed in the header; Set a view model property that indicates if the list is full
class ListLayoutPresenter extends BaseLayoutPresenter<IListLayout> {

  /// The view communicating with this presenter
  IListLayout _view;

  /// The tag representing the view
  String _tag;

  /// Constructs a [ListLayoutPresenter] with an [IListLayout] and tag
  ListLayoutPresenter(this._view, this._tag, LoggerManager logger) : super(_view, _tag, logger);

  void initializeLayoutModel(){
//    _view.lModel.resultCount = _view.model?.items?.length??0;
  }
}

