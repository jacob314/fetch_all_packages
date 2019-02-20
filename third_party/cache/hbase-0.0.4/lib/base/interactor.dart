import 'package:hbase/base/interface/i_interactor.dart';
import 'package:hbase/base/interface/i_presenter.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class Interactor<P extends IPresenter> implements IInteractor<P> {
  P mPresenter;

  Interactor(P presenter) {
    mPresenter = presenter;
  }
}
