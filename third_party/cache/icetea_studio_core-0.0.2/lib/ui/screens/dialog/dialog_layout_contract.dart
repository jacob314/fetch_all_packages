
//abstract class IDialogLayout<V extends IBaseDialogVM> extends IBaseLayout<V, V> {
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_contract.dart';
import 'package:icetea_studio_core/ui/view_models/dialog/base_dialog_vm.dart';

abstract class IDialogLayout<V extends IBaseDialogVM> extends IBaseLayout<V> {
  void close([dynamic result]);
  void showAction();
}