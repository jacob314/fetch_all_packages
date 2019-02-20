
import 'package:icetea_studio_core/ui/view_models/layout/base_layout_vm.dart';

class IBaseDialogVM extends IBaseLayoutVM {
  bool _isShowAction = false;
  bool get isShowAction => _isShowAction;
  set isShowAction(bool isShowAction) => _isShowAction = isShowAction;
}