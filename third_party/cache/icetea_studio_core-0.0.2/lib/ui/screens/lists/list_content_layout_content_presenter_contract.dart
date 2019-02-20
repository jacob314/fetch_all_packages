
import 'package:icetea_studio_core/ui/screens/lists/list_layout_content_presenter_contract.dart';

abstract class IListContentLayoutContentPresenter extends IListLayoutContentPresenter {
  void search(String keyword);
  void resetContentList();
}