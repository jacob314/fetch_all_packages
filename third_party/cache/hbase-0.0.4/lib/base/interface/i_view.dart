import 'package:hbase/base/interface/i_presenter.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class IView<P extends IPresenter> {
  P getPresenter();
}
