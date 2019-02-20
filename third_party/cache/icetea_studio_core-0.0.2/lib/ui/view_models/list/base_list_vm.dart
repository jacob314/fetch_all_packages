
import 'package:icetea_studio_core/ui/base/base_view_model.dart';
import 'package:icetea_studio_core/ui/view_models/list_item/list_item_base_vm_contract.dart';

abstract class BaseListVM<T extends ListItemBaseVM> extends IBaseVM {
    List<T> _items;
    List<T> get items => _items??[];
    set items(List<T> items) => _items = items;
}
