// GENERATED CODE - DO NOT MODIFY BY HAND

part of actions;

// **************************************************************************
// Generator: BuiltReduxGenerator
// **************************************************************************

class _$AppActions extends AppActions {
  factory _$AppActions() => new _$AppActions._();
  _$AppActions._() : super._();

  final ActionDispatcher<SubscriptionPayload<Duration>> timeStream =
      new ActionDispatcher<SubscriptionPayload<Duration>>('AppActions-timeStream');
  final ActionDispatcher<Duration> setDuration =
      new ActionDispatcher<Duration>('AppActions-setDuration');
  final ActionDispatcher<int> setNow =
      new ActionDispatcher<int>('AppActions-setNow');
  final ActionDispatcher<bool> setIsStarted =
      new ActionDispatcher<bool>('AppActions-setIsStarted');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    timeStream.setDispatcher(dispatcher);
    setDuration.setDispatcher(dispatcher);
    setNow.setDispatcher(dispatcher);
    setIsStarted.setDispatcher(dispatcher);
  }
}

class AppActionsNames {
  static final ActionName<SubscriptionPayload<Duration>> timeStream =
      new ActionName<SubscriptionPayload<Duration>>('AppActions-timeStream');
  static final ActionName<Duration> setDuration =
      new ActionName<Duration>('AppActions-setDuration');
  static final ActionName<int> setNow =
      new ActionName<int>('AppActions-setNow');
  static final ActionName<bool> setIsStarted =
      new ActionName<bool>('AppActions-setIsStarted');
}
