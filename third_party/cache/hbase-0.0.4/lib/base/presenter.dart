import 'package:hbase/base/interface/i_interactor.dart';
import 'package:hbase/base/interface/i_presenter.dart';
import 'package:hbase/base/interface/i_view.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class Presenter<V extends IView, I extends IInteractor>
    implements IPresenter<V, I> {
  V mView;
  I mInteractor;

  I getInteractor() {
    return mInteractor;
  }

  V getView() {
    return mView;
  }
}
