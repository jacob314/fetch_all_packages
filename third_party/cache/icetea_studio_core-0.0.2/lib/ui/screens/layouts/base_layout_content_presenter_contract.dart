
/// Define the interface the layout can use to talk to the content presenter
abstract class IBaseLayoutContentPresenter{

     /// Used to control when content should start loading
     ///
     /// Typically, the content is initialized when the presenter is created. Sometimes, this is not the case as the page might want
     /// to control when the content should be initialized (e.g. User confirms an action before the content should start being loaded)
     void initializeContent();
}