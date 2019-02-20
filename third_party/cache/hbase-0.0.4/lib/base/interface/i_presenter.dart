import 'package:hbase/base/interface/i_interactor.dart';
import 'package:hbase/base/interface/i_view.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class IPresenter<V extends IView, I extends IInteractor> {
  V getView();

  I onCreateInteractor();

  V onCreateView(data);

  I getInteractor();
}
