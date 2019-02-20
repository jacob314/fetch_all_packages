import 'package:hbase/base/interface/i_interactor.dart';
import 'package:hbase/base/interface/i_presenter.dart';

// ignore: strong_mode_not_instantiated_bound
abstract class PresenterView<P extends IPresenter> extends IInteractor<P> {}
