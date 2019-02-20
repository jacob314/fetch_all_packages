library view_model;

import 'package:flutter/widgets.dart';
import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability);
}

const view_model = const Reflector();

class ViewModelProvider {

  static T provide<T extends ViewModel>(Type type ,{ViewModelFactory factory}) {
    var viewModel;
    if (factory != null) {
      viewModel = factory.crateViewModel(type);
    } else {
      ClassMirror classMirror = view_model.reflectType(type);
      viewModel = classMirror.newInstance('', null) as T;
    }
    return viewModel;
  }
}

abstract class ViewModelFactory {
  T crateViewModel<T extends ViewModel>(Type type);
}

@view_model
class ViewModel extends Disposed {

  static T of<T extends ViewModel>(BuildContext context) {
    var tmp = ViewModelInherited<T>();
    Type type = tmp.runtimeType;
//    Type type = _InheritedViewModel<T>; TODO: should be so
    var iVM = context.inheritFromWidgetOfExactType(type) as ViewModelInherited<T>;
    return iVM.viewModel;
  }

  @override
  void dispose() {}
}

abstract class Disposed {
  void dispose() {}
}

class ViewModelInherited<T extends ViewModel> extends InheritedWidget {
  final T viewModel;

  ViewModelInherited({this.viewModel, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(ViewModelInherited oldWidget) =>
      viewModel != oldWidget.viewModel;

}
