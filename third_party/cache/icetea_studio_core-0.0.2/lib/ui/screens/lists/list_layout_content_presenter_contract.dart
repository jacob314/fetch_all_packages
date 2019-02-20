
import 'package:icetea_studio_core/ui/screens/layouts/base_layout_content_presenter_contract.dart';

abstract class IListLayoutContentPresenter extends IBaseLayoutContentPresenter {
  // Define the interface the layout can use to talk to the content presenter

  void getSuggestions(String keyword);
  void refreshList();
  void loadNextBatch();
}