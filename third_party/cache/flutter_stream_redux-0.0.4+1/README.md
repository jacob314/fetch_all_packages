# flutter_stream_redux

Stream helper for build_redux and flutter_build_redux

## Getting Started with StreamMiddleware
### Add action
In you action file add the action that you want to trigger the stream subscription. The payload of this action should be 
of type **SubscriptionPayload**. The type of SubscriptionPayload should be the type of payload you want to receive in the 
*getStream* method in the MiddlewareStreamHandler. It can also be of type Null if you don't want to receive anything. 
In the example we have a payload type of Duration witch is the interval 
at witch we emit a new value:
            
    ActionDispatcher<SubscriptionPayload<Duration>> get timeStream;
    
### Create the stream middleware
#### Create middleware
We can create the the middleware using the **MiddlewareStreamBuilder** and add the actions you've created on the previous step.
Note that only actions with the payload type of **SubscriptionPayload** are accepted. 
        
    Middleware<AppState, AppStateBuilder, AppActions> getStreamMiddleware() {
      final MiddlewareStreamBuilder<AppState, AppStateBuilder, AppActions> builder =
          new MiddlewareStreamBuilder<AppState, AppStateBuilder, AppActions>();
    
      builder..add(AppActionsNames.timeStream, new TimeStreamHandler());
    
      return builder.build();
    }

#### Add you action handler class
To handle the middleware action you need to create a class that extends **MiddlewareStreamHandler<AppState, AppStateBuilder,
AppActions, *Payload*, *StreamType*>**.
 
The **Payload** is the type of the **SubscriptionPayload\<*Payload*\>** object you've added in the first step.
In *getStream* you receive the payload you've passed when you called the triggering action.

The **StreamType** is the type of the object you stream produces, like **Stream<*StreamType*>**. 

In the *getStream* method you need to return the stream you want to listen to. *onData* is called each time a new value was emitted. 
You can also handle errors and stream close using the other callbacks. You can also chose to cancel the stream on error
by overriding the *cancelOnError* field, default is false.
     
    class TimeStreamHandler extends MiddlewareStreamHandler<AppState, AppStateBuilder, AppActions, Duration, int> {
      static final Log log = new Log('TimeStreamHandler');
    
      @override
      Stream<int> getStream(Duration payload) {
        //initialize your stream here
      }
    
      @override
      void onData(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
          Action<SubscriptionPayload<Duration>> action, int event) {
        //handle new data emited
      }
    
      @override
      void onError(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, dynamic error, StackTrace stackTrace) {
        log.d(error);
      }
    
      @override
      void onDone(MiddlewareApi<AppState, AppStateBuilder, AppActions> api) {
        log.d('done');
      }
      
      @override
      bool get cancelOnError => false;
    }

### Add the stream middleware to your store
You just add you stream middleware to you middleware list of your Store.
    
      final Store<AppState, AppStateBuilder, AppActions> store = new Store<AppState, AppStateBuilder, AppActions>(
        reducerBuilder,
        new AppState.initialState(),
        new AppActions(),
        middleware: <Middleware<AppState, AppStateBuilder, AppActions>>[
          createStoreMiddleware(),
          getStreamMiddleware(),
        ],
      );
          
#### Start listening to the stream.
To start listening to the stream you can now call the action you've create. When you subscribe you must give the payload 
you want to receive in *getStream* method in the **MiddlewareStreamHandler**. In this way you can manually subscribe and
unsubscribe from the stream.
    
    actions.timeStream(SubscriptionPayload.subscribe(duration));
    
    actions.timeStream(SubscriptionPayload.unsubscribe);

## Getting Started with StreamedStoreConnector
If you want to remain subscribed to the stream as long as the Widget is on screen then you can use the
 **StreamedStoreConnector<StoreState, Actions, LocalState, Payload>**
witch automatically manages the subscription for you. This is a thin wrapper around the **StoreConnector** from the 
flutter_built_redux package.

There are two more overrides to make this work. 

**streamAction** is the action that triggers the subscription

**subscribePayload** is the payload you would normally pass to the subscription action. **Payload** is the type of the 
**SubscriptionPayload\<Payload\>**

    class NowStreamConnector extends StreamedStoreConnector<AppState, AppActions, int, Duration> {
      static final Log log = new Log('NowStreamConnector');
    
      NowStreamConnector({@required this.builder, @required this.duration});
    
      final ViewModelBuilder<int> builder;
    
      final Duration duration;
    
      @override
      Duration get subscribePayload => duration;
    
      @override
      ActionDispatcher<SubscriptionPayload<Duration>> streamAction(AppActions actions) => actions.timeStream;
    
      @override
      int connect(AppState state) => state.now;
    
      @override
      Widget build(BuildContext context, int now, AppActions actions) {
        return builder(context, now);
      }
    }
    
The logger package is https://pub.dartlang.org/packages/flutter_logger