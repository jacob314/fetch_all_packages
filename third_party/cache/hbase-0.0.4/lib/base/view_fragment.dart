import 'package:hbase/base/interface/i_presenter.dart';
import 'package:hbase/base/interface/presenter_view.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class ViewFragment<P extends IPresenter> implements PresenterView<P> {
  P mPresenter;

  void setPresenter(P presenter) {
    mPresenter = presenter;
  }

  P getPresenter() {
    return mPresenter;
  }
}
