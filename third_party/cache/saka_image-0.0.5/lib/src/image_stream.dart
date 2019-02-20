import 'dart:async';
import 'dart:ui' as ui show Codec, FrameInfo;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:saka_image/src/image_type.dart';
import 'package:saka_image/src/log.dart';

class ComposeImageInfo {
  final ui.Codec codec;
  final ImageType type;

  ComposeImageInfo(this.codec, this.type);
}

typedef ImageChangeListener = void Function(ImageType type);

class _ImageListenerPair {
  _ImageListenerPair(this.listener, this.changeListener, this.errorListener);

  final ImageListener listener;
  final ImageChangeListener changeListener;
  final ImageErrorListener errorListener;
}

class SakaImageStream extends Diagnosticable {
  SakaImageStream();

  SakaBaseStreamCompleter get completer => _completer;
  SakaBaseStreamCompleter _completer;

  List<_ImageListenerPair> _listeners;

  void setCompleter(SakaBaseStreamCompleter value) {
    assert(_completer == null);
    _completer = value;
    if (_listeners != null) {
      final List<_ImageListenerPair> initialListeners = _listeners;
      _listeners = null;
      for (_ImageListenerPair listenerPair in initialListeners) {
        _completer.addListener(
          listenerPair.listener,
          onChange: listenerPair.changeListener,
          onError: listenerPair.errorListener,
        );
      }
    }
  }

  /// Adds a listener callback that is called whenever a new concrete [ImageInfo]
  /// object is available. If a concrete image is already available, this object
  /// will call the listener synchronously.
  ///
  /// If the assigned [completer] completes multiple images over its lifetime,
  /// this listener will fire multiple times.
  ///
  /// The listener will be passed a flag indicating whether a synchronous call
  /// occurred. If the listener is added within a render object paint function,
  /// then use this flag to avoid calling [RenderObject.markNeedsPaint] during
  /// a paint.
  ///
  /// An [ImageErrorListener] can also optionally be added along with the
  /// `listener`. If an error occurred, `onError` will be called instead of
  /// `listener`.
  ///
  /// Many `listener`s can have the same `onError` and one `listener` can also
  /// have multiple `onError` by invoking [addListener] multiple times with
  /// a different `onError` each time.
  void addListener(ImageListener listener,
      {ImageChangeListener onChange, ImageErrorListener onError}) {
    if (_completer != null)
      return _completer.addListener(listener,
          onChange: onChange, onError: onError);
    _listeners ??= <_ImageListenerPair>[];
    _listeners.add(_ImageListenerPair(listener, onChange, onError));
  }

  /// Stop listening for new concrete [ImageInfo] objects and errors from
  /// the `listener`'s associated [ImageErrorListener].
  void removeListener(ImageListener listener) {
    if (_completer != null) return _completer.removeListener(listener);
    assert(_listeners != null);
    for (int i = 0; i < _listeners.length; ++i) {
      if (_listeners[i].listener == listener) {
        _listeners.removeAt(i);
        continue;
      }
    }
  }

  /// Returns an object which can be used with `==` to determine if this
  /// [ImageStream] shares the same listeners list as another [ImageStream].
  ///
  /// This can be used to avoid unregistering and reregistering listeners after
  /// calling [ImageProvider.resolve] on a new, but possibly equivalent,
  /// [ImageProvider].
  ///
  /// The key may change once in the lifetime of the object. When it changes, it
  /// will go from being different than other [ImageStream]'s keys to
  /// potentially being the same as others'. No notification is sent when this
  /// happens.
  Object get key => _completer != null ? _completer : this;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ImageStreamCompleter>(
      'completer',
      _completer,
      ifPresent: _completer?.toStringShort(),
      ifNull: 'unresolved',
    ));
    properties.add(ObjectFlagProperty<List<_ImageListenerPair>>(
      'listeners',
      _listeners,
      ifPresent:
          '${_listeners?.length} listener${_listeners?.length == 1 ? "" : "s"}',
      ifNull: 'no listeners',
      level: _completer != null ? DiagnosticLevel.hidden : DiagnosticLevel.info,
    ));
    _completer?.debugFillProperties(properties);
  }
}

abstract class SakaBaseStreamCompleter extends ImageStreamCompleter {
  final List<_ImageListenerPair> _listeners = <_ImageListenerPair>[];
  final InformationCollector _informationCollector;

  bool get _hasActiveListeners => _listeners.isNotEmpty;
  ui.Codec _codec;
  Timer timer;

  SakaBaseStreamCompleter(this._informationCollector) : timer = null;

  @override
  void addListener(ImageListener listener,
      {ImageChangeListener onChange, ImageErrorListener onError}) {
    if (!_hasActiveListeners && _codec != null) {
      _decodeNextFrameAndSchedule();
    }
    super.addListener(listener, onError: onError);
    _listeners.add(_ImageListenerPair(listener, onChange, onError));
  }

  @override
  void removeListener(ImageListener listener) {
    super.removeListener(listener);
    for (int i = 0; i < _listeners.length; ++i) {
      if (_listeners[i].listener == listener) {
        _listeners.removeAt(i);
        continue;
      }
    }
    if (!_hasActiveListeners) {
      timer?.cancel();
      timer = null;
    }
  }

  void _handleError(String context, dynamic error, StackTrace stack) {
    reportError(
      context: context,
      exception: error,
      stack: stack,
      informationCollector: _informationCollector,
      silent: true,
    );
  }

  @protected
  _handleCodecReady(ComposeImageInfo info);

  @protected
  Future<void> _decodeNextFrameAndSchedule();
}

class SakaImageStreamCompleter extends SakaBaseStreamCompleter {
  final double _timeScale;
  final double _scale;

  ui.FrameInfo _nextFrame;

  // When the current was first shown.
  Duration _shownTimestamp;

  // The requested duration for the current frame;
  Duration _frameDuration;

  // How many frames have been emitted so far.
  int _framesEmitted;

  SakaImageStreamCompleter({
    @required Future<ComposeImageInfo> codec,
    @required double scale,
    double timeScale,
    InformationCollector informationCollector,
  })  : assert(timeScale != 0),
        _framesEmitted = 0,
        _timeScale = timeScale ?? 1.0,
        _scale = scale ?? 1.0,
        super(informationCollector) {
    codec.then<void>(_handleCodecReady, onError: _handleError);
  }

  @override
  Future<void> _decodeNextFrameAndSchedule() async {
    try {
      _nextFrame = await _codec.getNextFrame();
    } catch (exception, stack) {
      _handleError('resolving an image frame', exception, stack);
      return;
    }
    if (_codec.frameCount == 1) {
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      return;
    }
    SchedulerBinding.instance.scheduleFrameCallback(_handleAppFrame);
  }

  void _emitFrame(ImageInfo imageInfo) {
    setImage(imageInfo);
    _framesEmitted += 1;
  }

  void _handleAppFrame(Duration timestamp) {
    if (!_hasActiveListeners) return;
    if (_isFirstFrame() || _hasFrameDurationPassed(timestamp)) {
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      _shownTimestamp = timestamp;
      _frameDuration = _nextFrame.duration * _timeScale;
      _nextFrame = null;
      final int completedCycles = _framesEmitted ~/ _codec.frameCount;
      if (_codec.repetitionCount == -1 ||
          completedCycles <= _codec.repetitionCount) {
        _decodeNextFrameAndSchedule();
      }
      return;
    }
    final Duration delay = _frameDuration - (timestamp - _shownTimestamp);
    timer = Timer(delay * timeDilation, () {
      SchedulerBinding.instance.scheduleFrameCallback(_handleAppFrame);
    });
  }

  bool _isFirstFrame() {
    return _frameDuration == null;
  }

  bool _hasFrameDurationPassed(Duration timestamp) {
    assert(_shownTimestamp != null);
    return timestamp - _shownTimestamp >= _frameDuration;
  }

  @override
  _handleCodecReady(ComposeImageInfo info) {
    if (info == null || info.codec == null) {
      return;
    }
    _codec = info.codec;
    _framesEmitted = 0;
    _frameDuration = null;
    onImageChanged(info.type);
    _decodeNextFrameAndSchedule();
  }

  void onImageChanged(ImageType type) {
    final List<ImageChangeListener> localListeners = _listeners
        .map((_ImageListenerPair listenerPair) => listenerPair.changeListener)
        .toList();
    if (localListeners.isEmpty) {
      return;
    }
    for (ImageChangeListener listener in localListeners) {
      if (listener == null) {
        continue;
      }
      try {
        listener(type);
      } catch (exception, stack) {
        _handleError('ImageChangeListener', exception, stack);
      }
    }
  }
}

class SakaComposeImageStreamCompleter extends SakaImageStreamCompleter {
  SakaComposeImageStreamCompleter({
    @required Future<ComposeImageInfo> codec,
    @required double scale,
    double timeScale = 1.0,
    Future<ComposeImageInfo> prePlaceHolderCodec,
    InformationCollector informationCollector,
    this.inDuration,
    this.outDuration,
    this.waitInAnimation = true,
  })  : assert(codec != null),
        assert(timeScale != null),
        super(
            codec: codec,
            scale: scale,
            informationCollector: informationCollector,
            timeScale: timeScale) {
    prePlaceHolderCodec?.then(_handlePreCodecReady, onError: _handleError);
  }

  final Duration inDuration;
  final Duration outDuration;
  final bool waitInAnimation;

  //deal with the prePlaceHolder
  void _handlePreCodecReady(ComposeImageInfo info) {
    if (info == null || info.codec == null) {
      return;
    }
    _codec = info.codec;
    onImageChanged(info.type);
    _decodeNextFrameAndSchedule();
  }

  @override
  void _handleCodecReady(ComposeImageInfo info) {
    if (info == null || info.codec == null) {
      return;
    }
    onImageChanged(ImageType.OUT_DURATION);
    Future.delayed(outDuration, () {
      _handleOutDuration(info);
    });
  }

  void _handleOutDuration(ComposeImageInfo info) {
    _codec = info.codec;
    _framesEmitted = 0;
    _frameDuration = null;
    onImageChanged(info.type);
    _decodeNextFrameAndSchedule();
  }

  void _handleInDuration() {
    Future.delayed(outDuration, () => _decodeNextFrameAndSchedule());
  }

  void _handleAppFrame(Duration timestamp) {
    if (!_hasActiveListeners) return;
    if (_isFirstFrame()) {
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      _shownTimestamp = timestamp;
      _frameDuration = _nextFrame.duration * _timeScale;
      _nextFrame = null;
      final int completedCycles = _framesEmitted ~/ _codec.frameCount;
      if (_codec.repetitionCount == -1 ||
          completedCycles <= _codec.repetitionCount) {
        if (this.waitInAnimation) {
          onImageChanged(ImageType.IN_DURATION);
          _handleInDuration();
        } else {
          _decodeNextFrameAndSchedule();
        }
      }
      return;
    }
    if (_hasFrameDurationPassed(timestamp)) {
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      _shownTimestamp = timestamp;
      _frameDuration = _nextFrame.duration * _timeScale;
      _nextFrame = null;
      final int completedCycles = _framesEmitted ~/ _codec.frameCount;
      if (_codec.repetitionCount == -1 ||
          completedCycles <= _codec.repetitionCount) {
        _decodeNextFrameAndSchedule();
      }
      return;
    }
    final Duration delay = _frameDuration - (timestamp - _shownTimestamp);
    timer = Timer(delay * timeDilation, () {
      SchedulerBinding.instance.scheduleFrameCallback(_handleAppFrame);
    });
  }

  Future<void> _decodeNextFrameAndSchedule() async {
    try {
      _nextFrame = await _codec.getNextFrame();
    } catch (exception, stack) {
      reportError(
        context: 'resolving an image frame',
        exception: exception,
        stack: stack,
        informationCollector: _informationCollector,
        silent: true,
      );
      return;
    }
    if (_codec.frameCount == 1) {
      // This is not an animated image, just return it and don't schedule more
      // frames.
      _emitFrame(ImageInfo(image: _nextFrame.image, scale: _scale));
      return;
    }
    SchedulerBinding.instance.scheduleFrameCallback(_handleAppFrame);
  }
}
