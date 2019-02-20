
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:icetea_studio_core/ui/base/base_presenter.dart';
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_contract.dart';

/// The presenter of the [BaseLayout] view
///
/// Responsible for the View Model and View Logics for the Layout UI components (i.e. Currently Header and Body)
/// Ex: Update the # of list items displayed in the header; Set a view model property that indicates if the list is full
class BaseLayoutPresenter<V extends IBaseLayout> extends BasePresenter<V> {

  /// The view communicating with this presenter
  V _view;

  /// The tag representing the view
  String _tag;

  /// Constructs a [BaseLayoutPresenter] with an [IBaseLayoutContract] and tag
  BaseLayoutPresenter(this._view, this._tag, LoggerManager logger) : super(_view, _tag, logger);
}

