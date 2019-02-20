
import 'package:icetea_studio_core/ui/base/base_view_contract.dart';
import 'package:icetea_studio_core/ui/base/base_view_model.dart';

/// Contains the base interface required by a presenter to communicate with a layout
///
/// All screens in Voyager should be a child of this layout or one of its extensions.
/// This interface should only include APIs used by any child screen to communicate directly to this base layout
///
/// E.g:
/// - Let the layout know that the content has started loading
/// - Let the layout know that the content has completed loading and is now ready for building
/// - Let the layout know that there was an error loading the content
/// -

abstract class IBaseLayout<T extends IBaseVM> extends IBaseViewContract<T>{

  /// When the content of the screen has just been initialized
  void onContentInitialized();
  void onContentLoading();
}
